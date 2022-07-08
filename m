Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1859156BC7D
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 17:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238199AbiGHPEK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 11:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237500AbiGHPEI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 11:04:08 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C072CE10
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 08:04:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fm+OyC/uxGPmuJRlw1altKyDMt727h8GSmVMFfYKZDZUT+yS9kGZyQbPedF670IA900+S6oiehbrKz/LybVIwe3MXMisbtQe9RK5uIyDsYp6iUG90VA4+bJ9uv7pzD3MdCqkz1WbEQ+U9AIe/iuEMJtYYwWeRnWKe4v4wAyzpVabcntudkJrGQ7ziF64ncHP8dkwGgfdZwGSsFgD/iga8neohMl3VEjktoqiOQ4kC7YOktAPMqKREWJLLK5iri4ncT2xfAfjIMZ1QuB1KGbFo4x+g1Jr90kqnhd2yqqCwbLGdyxa37pW3SJxEWIw5jekpomAaUF6goNjLw6R7YhMoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jIpt2npn/Jke2MganAmi6/w6UNBMvBJ/BEbCETSMzzE=;
 b=jkHLkRHpwW+kkIRsM6QnLpr5j2Vk3x7evA3XIMPuhZwARuwGtTxMnuYdVWJbnGLyTyPxND6bZmam4YV0WfDwokNWEi03pt9DgwkhyxbnudADMAHT09gh/QdynKnqLqbnfyF3Ksj4pfm6Eqv7NzLUDblNUxLmUSO2SjaJ5WtdlEXA+8qC5xZj7/jASGrOO/BUF3tvFrmrf7y9DWviooLI5poGeA4vk2USyO50ZoC8YYO7RkyVe4yJwTX/ix6xFblE/KLl2+ltm0H6+Gg+JIpF7UV2EOxt2v4oX97kfQoDK+cFlldDBZ8Vrvtdfv3lG3obC44ya9mR9rNwE9/TtgeUyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIpt2npn/Jke2MganAmi6/w6UNBMvBJ/BEbCETSMzzE=;
 b=IvaN3i7sQqT+ofb/joe+qqDR5RLKZBmrMDOmwWOKutihntunnLC+dePMLrIO2h77d/LLe2ZOoJOTZmim7bPoaxa4EyjBlS+bg49vuMIGFh/0z1dPee9QxSMvd1jgvjIhQYVs+SzagEQD2kTfJMGnIxv+vdUI7iX3a+fEmUJ+jYw=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by CH2PR10MB4263.namprd10.prod.outlook.com (2603:10b6:610:a6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Fri, 8 Jul
 2022 15:04:02 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::88b4:c67c:e2e2:7dbe]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::88b4:c67c:e2e2:7dbe%8]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 15:04:01 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: UIO mmap on ARM/ARM64 cannot do unaligned access
Thread-Topic: UIO mmap on ARM/ARM64 cannot do unaligned access
Thread-Index: AQHYktsFOSUQlv/sWUSF7PL2HT80Ig==
Date:   Fri, 8 Jul 2022 15:04:01 +0000
Message-ID: <PH0PR10MB461574A61EBF73055D3B0F13F4829@PH0PR10MB4615.namprd10.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: b8b0d253-f810-69a6-a34a-4dd4c2788b36
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=infinera.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6b6a573-a41d-4ef9-a2d8-08da60f317ca
x-ms-traffictypediagnostic: CH2PR10MB4263:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wURLq9Fx/XkR2IK3ETl2UvKQt5gxV1SaIJEXSz0mxrUz8qVBq3l53B0OxPi2GLA6tqAdihLR18fTADObjYsQc3rNrU5tT7mhZrqR7Pl+FRG51WwmBlz9XhS9Ejlp2hfa7sDoS1fDlOXE5A8JEuEhMA8j+vWLBKVCBdGZfjPk9XPcLd3KmiR6GLo5cmI2KQ2VUjrYxzoN8khREo3A0VEQ+F6S8EBBMqOG2IrMWmbQDWXly0R3voSkBWSpdYhO9iG7ODg27zUlDT3bBKuoSXV+f00QxDZzqgcU3ryIi0mHF0oSwZVkCQ9iOEsOBAU01777kVL/HE48fu74P03L9XyVKDSVyGkVfqpF08mJGF0IPs69EdHvaxEUxN5oSc8ceS8RXFkggT4q5JsRLq0lETMZAmQ/nWB1myP3mf0a50EfkwVnazWuOxsw8+Fivg4EA+ezdk0/J6Cd2AjFjah7BWLZ08vwM3EJczfF7TRva7dfdiWgu5Ppn0Zrwi48UyobHtuosZ6W4/p8AWlPmikSvnjOmVVkF1xNNRJ+5anYdGbudb7Y0JhdiNix/ojQrzNv2IBkqS/W6RhPtYBSrAFBRiSPH4aNcTWpxuA0O1si0voX9dBFUV+v0ZpcYxIzrH/aVZo5V3+EE9PNxCfvgLdimtOBQP4PcThvq3PebUTbGXX56K+qVpv6XBTHz0NPYN2N9Ghvi7zHoJnwDHDZkimQDiAsEptJfarfAq7ZteeY0E93rM4BZmoJSr0itVf+jWL1JFwrfns9fTWb1FhalBXM4J+XBrNzW7z8MD1YKvtz0xmYBptcH60/6uB2he+YzLxWeVN4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(376002)(39850400004)(346002)(396003)(110136005)(38070700005)(83380400001)(38100700002)(55016003)(122000001)(316002)(64756008)(76116006)(186003)(91956017)(66446008)(8676002)(9686003)(66556008)(66946007)(41300700001)(2906002)(71200400001)(7696005)(5660300002)(33656002)(6506007)(8936002)(86362001)(26005)(478600001)(52536014)(558084003)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?RIHhvzEas4qahKdmjWz/5H/cSQXal/ODnrZtfi1x4O6h0FhUoCUjcdWCWW?=
 =?iso-8859-1?Q?bnPBSMjLTP1sqW+Twxj5Uq1QoS8cF0+tGwN2bd5FfFEROlbkFEQrCuvKDa?=
 =?iso-8859-1?Q?MUBld/QkRyMuJThQjTw8pyxi83ZsHpVEOtWghPtgRyKYzaNWTa6iRpLK7G?=
 =?iso-8859-1?Q?kTwkEPbIs2XIz42BgXzm4iIrKBG5tB2TkqEopN2FDdV/bVSuXQWHnPeYsK?=
 =?iso-8859-1?Q?pFM6i+nrUXi6GZrdqWXBjg7vCudqhgQ2gqmkMag9Oh/lHCpp8oxHywBXdQ?=
 =?iso-8859-1?Q?cUyI8935yIIqfnDT/7+78WfT3l38Kpb1rfCxCY6mOUwXizrpaEY64Iq/k7?=
 =?iso-8859-1?Q?fYEKpXX3tbEcQhGESKox3HeZiBeaXZIvYiVf2dTJco24uURVwR2/bJI5S0?=
 =?iso-8859-1?Q?gpq2vWUTjmH5RrtRHRonPW9jx9UD1vr6Wx2xQeQPsHGcj9f6Vd4rxbTzyX?=
 =?iso-8859-1?Q?1/LtZZxxV54xCXSSk6A92bmO5Jg39XuBihdTQdZNGXIh6Vs+lFBiH2vCey?=
 =?iso-8859-1?Q?QRiK1w46U7PZft+M9iX+0e3ryrbINegidRPlM0HJx1p6rlK9qzfEx3Mfvy?=
 =?iso-8859-1?Q?9XXssvoyXjav57iFZ25UgusA+4nG2cTunL9yMcdQkk496revBWYkGoW25O?=
 =?iso-8859-1?Q?pKxZF2RIIaCi3/lSIQjqKkzNPh5iCzLEAvwBND+v2wht2dZyN3Gan51TtN?=
 =?iso-8859-1?Q?swnhMjeBfeWENkbXl2laPNjqy1cDcUYV8rdlowh2r8UU0w8oHv35OR+AKR?=
 =?iso-8859-1?Q?Q6jwN3G8YS5I15RPXlEMzSlyUIPDhpd8yP36qLxglz07TWtc+fZYR+ZP0/?=
 =?iso-8859-1?Q?BfjKRhD3TKcApza+pPvaiJgCbtqCmmTPpp7ly+HdhlQ0D1dAgn8tJoAOuJ?=
 =?iso-8859-1?Q?g+MC2l/lJ++ba8k6nGltNUp87GQ3C1t3bVV+VHU4v9ynhGCcN+DiBk5cg5?=
 =?iso-8859-1?Q?Q6UISXoCiICp1zES1IearjCURQWCRte0Ro54GkdjxIjQMf61iqquFvE6t1?=
 =?iso-8859-1?Q?RokTrhfd6NTz5FlbGlIBV7Z8lY/CGvSrrBrKTKOUqRp8OZ219FyroOvSu0?=
 =?iso-8859-1?Q?LbJqFopL/M4Ny0gQIuqWm7llZyIW/I56VvQmdilu1B54XsuKDvEDF8WJbA?=
 =?iso-8859-1?Q?G0ya5a5HfVkyjPZlmyKAf9r7bQTQXYgovV0RcRqCjS5dEuRI+Aio0KgFhk?=
 =?iso-8859-1?Q?eE/+9Uv5mGFPu8rN1Ub+d1r4GIor4ChaiWh4i6id8mNP337oOYmq7Bv1F+?=
 =?iso-8859-1?Q?FVSX3VkmWw04u6OwNcxD4hTyNs/fy40yHQr3dwRiqj+8yjNZjS8R3MbsEq?=
 =?iso-8859-1?Q?Ta3JHsMgUN2iXEyXPoM77QrCj5c/TaciE1N253ERmMLljr++b0plUtTGFD?=
 =?iso-8859-1?Q?BfjipuH1xaj57fqgfyD0EP3Xt7xJUxIxdZPhQsYMt3/sdsNMQkq/vv3iSo?=
 =?iso-8859-1?Q?xL0os0gOO1MqBcbMHovo1A8Zf6MlosseUClecN/8vWQAQtJrcTkcjHuuvg?=
 =?iso-8859-1?Q?9WcqC+tB7WPYHfp6a6OOvLjEzepQ4ghNp9Ma/Nr3gX8l3EVMdqd4XW72Rd?=
 =?iso-8859-1?Q?UUcKNc+UoaRE/4Yy1Zhjd3+bDoA9qkcgOQitmfAimeCNW8as3mLlk4HqaN?=
 =?iso-8859-1?Q?VrySStJMbmFzy6A00MvORA+6DpgJxREPJR?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6b6a573-a41d-4ef9-a2d8-08da60f317ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2022 15:04:01.8665
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1r7QAavGybQJJCnxuTeoibmm+IwHhdcGToY3oNv+rrHWZ+uELms4RmnYAQi8K+1XoiUkOxqiM8c70nPxYy7Ajg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4263
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Creating an UIO device for over RAM and mapping this space forces aligned a=
ccess only.=0A=
I believe this is is due to all mapping are created with pgprot_noncached()=
=0A=
=0A=
Maybe some way of creating mappings which can do unaligned access could be =
added?=0A=
=0A=
 Joakim=
