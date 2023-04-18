Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5556E5807
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 06:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjDREUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 00:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjDREUB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 00:20:01 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2074.outbound.protection.outlook.com [40.107.100.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABBA44B2;
        Mon, 17 Apr 2023 21:19:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYV6957xU8VFg3yU/glH0v7eRNTt6FpuYTtB/HLHQu4HsVlFDE0nqKXOMiWDUuLC1WmuPy91393kOwxWpkCYyJOX/IYnGmI9Ksj97FlADEeqMI9J0Ag+QB5JkDarKUODpYkZ0UVIsx25HRrms40UWRMMylNqQLNuZnTMX9XdEgAiSm4NFN5sFDMncO2KmSbH/IWKxMigNdGobXYqiytKN5tNDUgSATYxZ/8FKLjALTrDBVlrR8IifjNQ2Iou0S3J0seuhdorJBG94bfPvlfXuz5+n6vQ5ZW0PkLwJL445zkXnfYRLIirsgW0ZrefhIugRAPtE34ntK9DzvrCa2Rutg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n2AqbCwZen2b6yHx6yO1r5PfM13W8pfZ3MR/4z3SSFU=;
 b=kHF91l/PSmrT/0OLCudrY6HCVQvgqVa1hASTuVGI5nqEsNp/fWD+Ffayzm2tzDTsw8sICXxxQITwdpMR3yxXYonBkZuKi/jcesbGqD3B0nwS0UTgblQoAm7PhiqChMYlkaZX5lpHWKT0QSKBMwKqZzztTVzQFnrx+nRG8zuEyJP3DnVUiprXIVk+DkvkVPFd+r4AIoxZWIqfN6KH8ZqANeUeRimBNA7RBL5L7Dd0sQLsCRI1k0wkiITareBUS4STWOOan+GAIq3/xM0fx8YzwEkYg9yM4mgTN3V0uqtcwu8LFjW/GHaEcP8eoR8or2iG5lqse+JH3MnMOq5YOHp5QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2AqbCwZen2b6yHx6yO1r5PfM13W8pfZ3MR/4z3SSFU=;
 b=Gctfm8q9YyPSKq9xihtys677TaiPhZcaIGm3k8IVY+wd9ZJeG9hCqnHCQEZCeRdz67ELy+WOrW395h6zYaiH46tPLdLRQYh8+B74oTS28JuoDtkAVO+uY0u8tzrzB8wXR8QsOTE4KOL7twwNI62XH5/OZQlGxqZXX2Uf0nKimxQ=
Received: from CH3PR12MB8308.namprd12.prod.outlook.com (2603:10b6:610:131::8)
 by CH3PR12MB7715.namprd12.prod.outlook.com (2603:10b6:610:151::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 04:19:56 +0000
Received: from CH3PR12MB8308.namprd12.prod.outlook.com
 ([fe80::4e4f:3a93:b7bd:489c]) by CH3PR12MB8308.namprd12.prod.outlook.com
 ([fe80::4e4f:3a93:b7bd:489c%5]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 04:19:55 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "nicolas@fjasle.eu" <nicolas@fjasle.eu>,
        "git (AMD-Xilinx)" <git@amd.com>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Jansen Van Vuuren, Pieter" <pieter.jansen-van-vuuren@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>
Subject: RE: [PATCH v3] vfio/cdx: add support for CDX bus
Thread-Topic: [PATCH v3] vfio/cdx: add support for CDX bus
Thread-Index: AQHZcQfvtSdqXKkn302VMI1fKTNU2q8vjYIAgADqFeA=
Date:   Tue, 18 Apr 2023 04:19:55 +0000
Message-ID: <CH3PR12MB830835EA2E32609A3EC52CC1E89D9@CH3PR12MB8308.namprd12.prod.outlook.com>
References: <20230417083725.20193-1-nipun.gupta@amd.com>
 <20230417082040.16e0ac18.alex.williamson@redhat.com>
In-Reply-To: <20230417082040.16e0ac18.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2023-04-18T04:19:53Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=6de5846e-8e66-4d49-a8b4-63450a243835;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB8308:EE_|CH3PR12MB7715:EE_
x-ms-office365-filtering-correlation-id: 8cdec118-4b47-47f9-0f40-08db3fc42a2d
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /VWzTHornHOcVE6WH8VSJ5puqHhlyAxl8uUef+BPAJ8aGW/uoIHuvT82YDd30t2ZiKHVwi6kQpMWiajCFo3Vsqf0HMf1y3sBfGjj40U4uEGa/RuTGlQiyS/jwYzwiU/yj6EU/g5gEOlBVkmxmLyHh2GdK6Ujil44O0qPRl3x03xX74ejVILppjokX9Y1eOPJpxYmNuRD7IP0jxLlDDnOdJyscszVs3Ru/NR6w32g9VJztM1E6IYjYtS0P3OB0+qAUbSmgT4P1EEODe6XLByycpIcmyPci+0WwpgVqLoioiVJxOEmVWjYNcbB5P3C4em89087bf5hgor4q52mcfMuZPvUxx8UmdMynrnvWhI8Y9OXG1ATj413yXTE8uOVV8M1zfNLNvuvIqF64PKj1W5+3X2ZxFMg/yIQgGPLvXyhbx3DVNtFA8IpGJ8YBq2+jOVF2RQJgBDGZwRTRGBwrAcSi7KUx0qIYfNY0dGqa+Hp4kPxuPzbp9//o9+ECLJDbFJUFv5klr/3nK7jxl4s8FwOyp2yoiqALmqySL8jq7wmQOCElzqx/XEFZigcDVQGLaauuSy8vV2XRtFNwaJOdIoZBudZFC8vMLPAZL/oNfLfmATAixvrh4e/df1zaa69Lfxd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8308.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(39860400002)(366004)(346002)(451199021)(6506007)(26005)(9686003)(53546011)(55016003)(478600001)(86362001)(83380400001)(186003)(66556008)(7696005)(5660300002)(64756008)(52536014)(66946007)(33656002)(6916009)(4326008)(76116006)(8676002)(8936002)(2906002)(66446008)(41300700001)(38070700005)(71200400001)(316002)(38100700002)(66476007)(122000001)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zN7PFAzCrMnAahzcDKfl150s15YwNXcxZDj+8F5eFgI0dppsnp8Y1DaJgeDp?=
 =?us-ascii?Q?VkskxAbbg5a6+/qwid1bFZgx+2bGR6n9l2C9vHZNPCdAYqJZq6BiMq6MHC3i?=
 =?us-ascii?Q?LEnB29zYzqOgTpS2MxIZDI36VQ1xOQ7G484cFKdlJ3FReUBe5/okYENVNdnp?=
 =?us-ascii?Q?bxD3cSnvs7irpWL+OYJ98hkq7WCMgHulR5+Mez85OsCp7BqY6oY0EouVSqy8?=
 =?us-ascii?Q?Ps/5StrhnvFhy6V9cJ9//d8VSgCXmvKIBXJ+0s4PfJNYsPtIpTJYjeRT4lBV?=
 =?us-ascii?Q?zMEl1I9n530k/2W5vMAENIqSEmyQUciyNMxvjkeudUPMig/RClroO4sYQnX7?=
 =?us-ascii?Q?Rqz6TW/1oHbB7CYsmBwV+QtfyWmW6uTwYeYA2hB1zPsT7DLvdmJj07X4i+0k?=
 =?us-ascii?Q?H0CYVnWTf7p2ZXUwIspAQXOloknHZwoKWIhyingfpiLwUMaR9VmfeWqgFtMF?=
 =?us-ascii?Q?UlqH7ce56jXaasVsPvddX5sXKQv4QiUjX52G7FzMcMvIeukOOCMgWAFc9Sxi?=
 =?us-ascii?Q?nxlBzO+MEC4LnVDxrp3A4FL4f7H9CtGNTLjllivH3j+qWsDsRBrSEtKvamYs?=
 =?us-ascii?Q?DJyGuoOg3Ty4b2A+SvaItzHBkfcXqw/4iBAZ+sFp0OGsMSfJbwgJVFIixV7P?=
 =?us-ascii?Q?MrvPIfvv0TPYw51F3ZBU2XLCuizNtMSZ0NgiSkyhWhRapf4904e2so9w8JIw?=
 =?us-ascii?Q?5MBp0Ri9TY8BlHYnG1+rghiqS2qxWS78h7GVcOsQ4efSmqq4Jy5JBLsIzx5G?=
 =?us-ascii?Q?eoK/QI3GsUUzwgI0p3yFa99Ppn4tQx67kpRR2hC07MuS8nt9K1/yA5VX2NR1?=
 =?us-ascii?Q?aSTY1vuAAGfqS4hTE67YsbtQ1VszWrm6aBTUC0pPmJfiAgO8/sSRzmC/GnSn?=
 =?us-ascii?Q?guIkmvQETe6EoFuS/Huled3eWkwYzpOsRuUWN6GuPbvu+2QkrWUugXlZTuwQ?=
 =?us-ascii?Q?RTsUSif26mhJwAMfoGotbRI7rDO3U0AFpxaWp70IND9iJGgmF+9ADHh9BZBi?=
 =?us-ascii?Q?9DoOT03q7uMfAxBoJgI86ca0A9GqqD5yygy3fOEXr5tAakFvmvmL/2Ldd/1h?=
 =?us-ascii?Q?yFJ487jEbE8mCkc0Y1UPvzhpgfoYreHTS/J5dU9rrvMDjTCnM6+33SIawSUL?=
 =?us-ascii?Q?dyCKKvVy8nCa45FiFS0AYzRgfbVHE/sBwYbtXnLKaQIpZ9QbDefres/kRheN?=
 =?us-ascii?Q?AUFq66h+nFkpOlAxzbHfH2h9CefldbpG27J8YLFPEqWpbRXvUFSZOujcVWhX?=
 =?us-ascii?Q?F8aB51I01ZNLB6EJF7pLjYb7wsSOskTIxYiIH227T9WLqlf3tUVOsV5fQmMu?=
 =?us-ascii?Q?aV4RggY/wmilqGuv1NqmcBmcE5+cPkhJK7UT5nB0SQsab720FVC3+4VmVsJU?=
 =?us-ascii?Q?+wFUVnlBAvI2VurThuYH+XbJDEkAcRT8kXliwEAI41xGhs/lkURQPh1wZp6o?=
 =?us-ascii?Q?pYaz3GejxINy24isv+d1Bz8F5/fhnAUVERZf18jOsqs2tRpBAkKx03JS8J+R?=
 =?us-ascii?Q?FD0iaQeejQcNJjbZIMcXSKBV7wbnbAZD1trcjFgCDCgzjH2fsUTzdnirrlg0?=
 =?us-ascii?Q?s+2snqO/ZuPANJAIEZ8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8308.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cdec118-4b47-47f9-0f40-08db3fc42a2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 04:19:55.6361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YlhKXqtS7AU3kDCgJ9bSqqGMA+ziKSqjA8JJqXimxeD0rh6tPBX8oin+/QNtZDOk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7715
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Monday, April 17, 2023 7:51 PM
> To: Gupta, Nipun <Nipun.Gupta@amd.com>
> Cc: jgg@ziepe.ca; linux-kernel@vger.kernel.org; kvm@vger.kernel.org;
> masahiroy@kernel.org; nathan@kernel.org; ndesaulniers@google.com;
> nicolas@fjasle.eu; git (AMD-Xilinx) <git@amd.com>; Anand, Harpreet
> <harpreet.anand@amd.com>; Jansen Van Vuuren, Pieter <pieter.jansen-
> van-vuuren@amd.com>; Agarwal, Nikhil <nikhil.agarwal@amd.com>; Simek,
> Michal <michal.simek@amd.com>
> Subject: Re: [PATCH v3] vfio/cdx: add support for CDX bus
>=20
> Caution: This message originated from an External Source. Use proper
> caution when opening attachments, clicking links, or responding.
>=20
>=20
> On Mon, 17 Apr 2023 14:07:25 +0530
> Nipun Gupta <nipun.gupta@amd.com> wrote:
>=20
> > +static long vfio_cdx_ioctl(struct vfio_device *core_vdev,
> > +                        unsigned int cmd, unsigned long arg)
> > +{
> > +     struct vfio_cdx_device *vdev =3D
> > +             container_of(core_vdev, struct vfio_cdx_device, vdev);
> > +     struct cdx_device *cdx_dev =3D to_cdx_device(core_vdev->dev);
> > +     unsigned long minsz;
> > +
> > +     switch (cmd) {
> > +     case VFIO_DEVICE_GET_INFO:
> > +     {
> > +             struct vfio_device_info info;
> > +
> > +             minsz =3D offsetofend(struct vfio_device_info, num_irqs);
> > +
> > +             if (copy_from_user(&info, (void __user *)arg, minsz))
> > +                     return -EFAULT;
> > +
> > +             if (info.argsz < minsz)
> > +                     return -EINVAL;
> > +
> > +             info.flags =3D VFIO_DEVICE_FLAGS_CDX;
> > +             info.flags =3D VFIO_DEVICE_FLAGS_RESET;
>=20
> Whoops, I think you mean |=3D for the latter one.  Thanks,

Oh!! Will send a quick v4 fixing this.

Thanks,
Nipun

>=20
> Alex
