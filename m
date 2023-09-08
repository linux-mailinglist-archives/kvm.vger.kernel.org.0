Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C968B798968
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 17:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244298AbjIHPBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 11:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244175AbjIHPBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 11:01:43 -0400
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376FD173B;
        Fri,  8 Sep 2023 08:01:39 -0700 (PDT)
Received: from pps.filterd (m0148664.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 388Er6nb004134;
        Fri, 8 Sep 2023 15:01:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=hUN94ZaE7GgUv94tJWnNwfYRIgxDQ2WwXipIuy5EOfo=;
 b=DwI+m+6hY/Jadhxsc2twrWFHYSFUsBuCuOR4tFBiw6oZMIcjkG+i8QYTVcDgZi+IyO0u
 a79XRJY4etSAG5MIuFKHQIQ5KcpNxgs2SlLuAWlcVkp5oOBm/mTIbJmTWR5zTsbCwv3A
 Kk78hhcKfYEZH9f6SQKuvroz8XFAgptqyl8g6dSNPa3wBEAr4ENjokH7T3DuST+VXAsm
 tTxBeLeOvdLqXwIUHfWOkbqt6x5DebFOpNgih3D3XBZp8dCmu8QmZiTeRlfB728pbGdy
 K1BxzfBxtt/5ofwu3SJBD1Ha0VLiVP0Od4Sg4ti2ljdVXgmq6GyYe9XHDe60RMIt42DR +A== 
Received: from p1lg14880.it.hpe.com ([16.230.97.201])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3t05rwr1y5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Sep 2023 15:01:20 +0000
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14880.it.hpe.com (Postfix) with ESMTPS id 7327F80038C;
        Fri,  8 Sep 2023 15:01:06 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Fri, 8 Sep 2023 03:01:05 -1200
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Fri, 8 Sep 2023 03:01:05 -1200
Received: from p1wg14921.americas.hpqcorp.net (16.230.19.124) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42
 via Frontend Transport; Fri, 8 Sep 2023 03:01:05 -1200
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (192.58.206.35)
 by edge.it.hpe.com (16.230.19.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Fri, 8 Sep 2023 03:01:05 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ezMVW0g7786bOW0f3aPyCeyJI39JGF9umI8PmlXuxVpPh4LWYYn7qNxvxp3lnI9xCzdsyPEyrkR9HyeqbV7bnDS4rJQofiy3yaMz7iIfdowIhHLYplKVTJ0C43bUxhZYmts+J5tvJOdoN+bi6CZxb/RyGoYy3Y475S2gbXJ9di0rNhJsZrse9MjU2RY3OTWtuthU6WkbDSFACUouPGvxgJaiobp7klfjY/AMUgFGpz3Z1YnMAUjBW7EEaIOqAVKZ1xwm5ppYCwiKNNPStVSVg2OD2EDtsW2y8qHVoHi+8E/ikdM9dQIYIqxNBOlm4vTjmDsOrae5qAXhFJusz+yQXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUN94ZaE7GgUv94tJWnNwfYRIgxDQ2WwXipIuy5EOfo=;
 b=oaWmbFyg78uBaOQJuKg6n+vzFZePrRJQEOIcJxT4rCJyWTCPXyRHBe3DLNEKlmzfoG7dKMLaI0hadghwm1xRJpCDgba1caqrC3oBYeV67L+aAmwUEdPlKFGzsCGA5lAILwA8SiR+lFq/dG8XWba3bR75b3H51CsGHkvVD2hldJ+PnHMLTMA23wtB2hi46D0nvoSwMLAhsrJ3acClecXl4islR3RAMLT3PJCht25EtYj9AoXtNnp7Lsn2MdXQp9weP4fClU/aQk6khHTFuFXf4uwSYD4K6m8O8SKzXHqPSesLlzniJv+bxeKgJje5RU7SrnbtAozF8DOWU7dOOcbQWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c0::18)
 by PH0PR84MB1407.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:172::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.36; Fri, 8 Sep
 2023 15:01:01 +0000
Received: from MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d03c:ba74:6f54:6091]) by MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d03c:ba74:6f54:6091%5]) with mapi id 15.20.6745.034; Fri, 8 Sep 2023
 15:01:01 +0000
From:   "Meyer, Kyle" <kyle.meyer@hpe.com>
To:     "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>
CC:     "Anderson, Russ" <russ.anderson@hpe.com>,
        "Sivanich, Dimitri" <dimitri.sivanich@hpe.com>,
        "Wahl, Steve" <steve.wahl@hpe.com>
Subject: Re: [PATCH v3] KVM: x86: Add CONFIG_KVM_MAX_NR_VCPUS
Thread-Topic: [PATCH v3] KVM: x86: Add CONFIG_KVM_MAX_NR_VCPUS
Thread-Index: AQHZ1tZc1nmOBFd5kEqRHDYSEipSi7ARHI4A
Date:   Fri, 8 Sep 2023 15:01:01 +0000
Message-ID: <MW5PR84MB171341BE0116F6048B5523039BEDA@MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM>
References: <20230824215244.3897419-1-kyle.meyer@hpe.com>
In-Reply-To: <20230824215244.3897419-1-kyle.meyer@hpe.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1713:EE_|PH0PR84MB1407:EE_
x-ms-office365-filtering-correlation-id: efbf12b0-34ca-4cdb-b8a9-08dbb07c6a6d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rc1naIgdBBtlSjUMYluaW0i9JmMd7CgSV2M6X9E79rPBGdQx1PA9bEeG5EcaGL73uNMPLu/3P7UTq4kmJTmmNEbnBuQIt+inJe1nBrwehQ0Dl2hX88Q5ztAGlJcahz/8szmICBLvQis777hNioC+EFq/ogW+6rrBcnrnZKadEaAm63TsT9Vggmi5luS2/y7rbaX7HP+Ie92rb/oNTz/H8nR3tUXKuy2Ze84M5zY5/HPGCsO3WImbBvt68iPoTG1vrSSXEsf6Xw0JKCLh30taBKYaJuyF0mdVfTT2l18Ga2nxv34kz721iK6An/ukNKV3Qhe8n6ksI+Dvj3Ir/buxiOJpI7ouNfwoyvqHalo572+8izDGeavidqH70Xv7hIIiDVo1xp1u3B6nI/MPOxx7Q4SE7oxycAg6LdB8Fr77D6vNMDlUV0Oa4b8L2h2XelCpbUSNaoG7Dq9bQH1BU/Ld2ED1ELIko/Bm+dum95VOkvhW/by3QtDIvvE6kiHiBmnbanqFEF+lL89AOaPnt7p47S3uxTO9URy/hLKFBYkXqKzpm3Of50QtyEKNK9bM5iypjMM8BTsB7uJ5Cts5fgNRm3tvWzL27Q6bv8PAC/85fVveGay4HN3rZgEg/lQWkWq7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(186009)(1800799009)(451199024)(71200400001)(6506007)(7696005)(478600001)(9686003)(91956017)(110136005)(2906002)(4270600006)(26005)(19618925003)(41300700001)(7416002)(66446008)(66476007)(66556008)(54906003)(316002)(66946007)(64756008)(8676002)(5660300002)(4326008)(52536014)(8936002)(33656002)(38070700005)(86362001)(55016003)(558084003)(38100700002)(921005)(76116006)(122000001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?//1vfKiR3mxJX1JAfwTZLhEPJIPtFKJp4rDUWllb1eZGdbKBOyhAySvzWd?=
 =?iso-8859-1?Q?LgN6DK9ikP9GVCT96agQ6wPWhL+ZzST0q04oLqhZ1+0Xci4E/kJxM8LahM?=
 =?iso-8859-1?Q?f8M/MNQH78VrxwbLk6QbsPAKCdSv2CpIcEVAcugEeV5ymgigk59wMNscoB?=
 =?iso-8859-1?Q?6jrB+fXUWlMTisiTOmpDD/VxAu+b/a5gTORYLzbieWN0yiMKXcwp8DmRFb?=
 =?iso-8859-1?Q?hU3Iar8wkkJK+9I8wDDG//7Dhq2tW1dfv7136Nd/fEdW9vMEzVivcDqzhH?=
 =?iso-8859-1?Q?gVtTWW0MY0sjKrFBiZ+ThfGvoKhL51s/M2mSASIgJUaML8MKfm99lyYYlH?=
 =?iso-8859-1?Q?yTWtfEpXtf1blV3YfxY0PgRPI+z6UJI2pIhDk58DXI8WUcxYjGIvEZC4Kg?=
 =?iso-8859-1?Q?SxtS/xsHkjZ+HxOTndQXn9AcwA48X6NWzTpzLVac0Vh9mrN42qQ0iiPk/H?=
 =?iso-8859-1?Q?AAiCBrfOBXYq8R6bYEFDHxdUrZe2YmEvpTwTZdmpejVdC9BrrMHThU8ECy?=
 =?iso-8859-1?Q?njIKwwnPzdXQJOGojlzV2ff1OCZlCXYcgetcutrQkbgsyrOwLcfUDPxnfH?=
 =?iso-8859-1?Q?G93eNUyyqFl701DVPEEHmP0IJsO6cbViHXLmjX6k/EseTug516ibdchKde?=
 =?iso-8859-1?Q?kJcQR3tcvROrf+GyBQ1s/kqWSE7MibhS9hRt3JkpHL7CwovJBMZfQ3Q3K8?=
 =?iso-8859-1?Q?YrMl/nke9QDSHWg2feBhcsMpvE9an3Ev/7mANff4YU4XYT20pOO331kUgs?=
 =?iso-8859-1?Q?gl6PIblqtLMLtkerj78pWPJFRqUgYU0bSAFSFU4tFT7U3cxOavpXduyA19?=
 =?iso-8859-1?Q?sJ9C/REVRtJt9Ctv+ONdqle3Xlk2TPlnHTl9Vt8iwhDXdETcpVb9OLJtXZ?=
 =?iso-8859-1?Q?UVoD5D2YBJeW7zXvH2HjlZrxjI5qxH6hlQDKcSwMYGf+fVAh1CjcY2x2Ma?=
 =?iso-8859-1?Q?FNXnTxO77Di1qxFUgJ0RdcKHuKmvqqP8dzbkN3gqaeWgiQJmATrhcc8qSz?=
 =?iso-8859-1?Q?O1YptVxN8NW/BwcG6jGJdDcWUs7Tt4KCIEnmbujglogF724Dwmzzg9IpNy?=
 =?iso-8859-1?Q?U09iK2HIwsSi8cc+R9R65ENudFvae7vN3Q8QRfzO5iQe3Uob7QnfBkD99U?=
 =?iso-8859-1?Q?8HtHRKvDCZMOj7lF7bpCpDBGpp7BKWTaXket+AfrY2yEsJSLoW90SbkucD?=
 =?iso-8859-1?Q?5ZW+v0oqEyEGsIPIE5jPv32pu4vMp/BGRUN8VzePZ9q2vYuirsLV4n4zSO?=
 =?iso-8859-1?Q?5R/K7I46kmza0z1HknWUwp/iJBkxDVr8oUC31PerUfkqKl5eyn1uwOY+15?=
 =?iso-8859-1?Q?svB5eelvI7v72VACj50LyNUJboh9mOPpGwiQGIGbFM/f3SLU9oTkHvtV4E?=
 =?iso-8859-1?Q?7VMSsfYKYfEq8PDZ97e2/ghd3yjEbnXhMpay38Wzy6hFgiK7bTlBIJVkT5?=
 =?iso-8859-1?Q?qDn7UCKpQqFDqz6UrmjH3fH/6GN+/770VM7zztAv1VKqmeyKgwr+iGxoZu?=
 =?iso-8859-1?Q?ftbjmfGXjJrEcccyAa/Zmh49CPufOo5OvUlsgYlqCcoDXjKYMETVPBo5yU?=
 =?iso-8859-1?Q?J/MQVPTyO2yOGjujB1frw3Fjt3B4Qp5TsicPi9xutSm3l08vhsKDLkKFYd?=
 =?iso-8859-1?Q?MqeGJ305K6ijY=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: efbf12b0-34ca-4cdb-b8a9-08dbb07c6a6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2023 15:01:01.0752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eWi31CVzuLIPdtwNAZh/Zh7+msW0ykDa0BynpnJeR9KcrHkbneuBijdKeiBAw0d2AOCUApcQ23ZB+H/ql0x+EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR84MB1407
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: wuzdozfC1OFw02zEgHCopp1m4g3TjsPi
X-Proofpoint-GUID: wuzdozfC1OFw02zEgHCopp1m4g3TjsPi
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-08_12,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 adultscore=0
 phishscore=0 mlxlogscore=621 spamscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309080139
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just a friendly ping.=
