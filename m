Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF3E39FD11
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 19:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhFHRGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 13:06:47 -0400
Received: from mail-bn8nam11on2137.outbound.protection.outlook.com ([40.107.236.137]:56001
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231840AbhFHRGq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 13:06:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MxvO/NsPWKyUgD+uoe27aeWWV1KEPxTyUWIWCuYALXYglQ8bN20WfleevAIAak5Lty7XyuxsgBK04O29I3Y0bLsRH5bxA5esHzPuQUC2ht18OtONhKs9GcwLiHLFTapWyROOhOnDm/fAk/EUjxVqbNF/PtQ8vwWdMHZn3xjzlm9bjolGNdLQogOiAudTrCbdvjnc0oUQQDTHp6I3ffn9W+ORDp9i9v8mrYpzBoXyqyZrBAAnY4LKmpgC/tNamaS2GCufxvAvgaHyAQE5uUNGOI4Bxk9/EXw4Jfi+r0J4e+8MqGAP5tnvA+myiF6uW3EJjk4EKcXX04grMx3DwqxfEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/TwmRDQnlIN7CFFLTFPGc1hbtujHfYyG3y10K3rDEBM=;
 b=J2BSMW0didnn8/+3+FQ0//ELMFCfx5RxVNcN/rK7go86IsyTPFs0rDJoXhCafffLisGZvHqPbyuoMEoBB08Wkd22lnl8nNxoS3RTc/mARakhfIZuxaEr33BZsumz644S/zWO8iZK32Ht1tF98PEl+exbw5P69wRWP1K01SMX+T/7RyIK9JMhH5ao84u4fUek9ArZiDgXZat1XMZ6pP9OBqIsOaNqAL6bpocxwHtPWFv0itkcELM1RpqIzw0CqUl9We4fE2WupsYymwqNzFG0qnWTA4RCE7NNNEZqaT8jOxIxTZNoD7fNwCmbbAWIjuO7QXESOqWaNEqpiCPPZ2QilA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/TwmRDQnlIN7CFFLTFPGc1hbtujHfYyG3y10K3rDEBM=;
 b=jkdrdVNHwXRloAZFdn6iT+8FklVrH6Rptu8CqTmX/55EdIuopBq+wArMTQJ5ltYC9Mw1xubmuJYnoIV0x1JjNA6w0X2B6RKE+4VQSapJjZdJM4dN05Vf7XI1OGcSXV+lSCIVw133SgrFsn+HkE56Ym0iGKGVrObszFKr+oDepOs=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MW2PR2101MB0906.namprd21.prod.outlook.com (2603:10b6:302:10::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.7; Tue, 8 Jun
 2021 17:04:47 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::8dbd:8360:af6:b8a2]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::8dbd:8360:af6:b8a2%9]) with mapi id 15.20.4242.007; Tue, 8 Jun 2021
 17:04:47 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Vineeth Pillai <viremana@linux.microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        vkuznets <vkuznets@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
CC:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        KY Srinivasan <kys@microsoft.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v5 2/7] hyperv: SVM enlightened TLB flush support flag
Thread-Topic: [PATCH v5 2/7] hyperv: SVM enlightened TLB flush support flag
Thread-Index: AQHXWIs1S0AmjDki9UyNn37L3PaB66sKXwsg
Date:   Tue, 8 Jun 2021 17:04:47 +0000
Message-ID: <MWHPR21MB15933E0F57E22504A4ADC2F1D7379@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <cover.1622730232.git.viremana@linux.microsoft.com>
 <a060f872d0df1955e52e30b877b3300485edb27c.1622730232.git.viremana@linux.microsoft.com>
In-Reply-To: <a060f872d0df1955e52e30b877b3300485edb27c.1622730232.git.viremana@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=fd98210b-d15a-431d-8ba1-1c4f8f1d0c8e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-06-08T17:02:30Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: linux.microsoft.com; dkim=none (message not signed)
 header.d=none;linux.microsoft.com; dmarc=none action=none
 header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efef7c32-9303-464e-eab7-08d92a9f8538
x-ms-traffictypediagnostic: MW2PR2101MB0906:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB09068E76A443BCF0D77758C9D7379@MW2PR2101MB0906.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E4isbPzCuWj5xZLqCfF+AUuUVaSJj9dhcmDHD3flxkNCQFTp6lnfGiC+0cXAaus95n1A5cdZrek2IAwA2Wfu6xWWYHYrKWAoXnijNpZZF68XXaO1od1XeysfOdPby/4yyVfw8opnFCHLvPODKut0dAl74m+4TlWTMHS++c7DRFiFLNvGWJxwYjvBcaTvX39QS0tRUWIaOS7aRQy0ez03od2P2TWX7o2h9p5CENLTVWYHeyMnazdcaYFDYIJokIM1fVU+HP0KsuXcQD07PzWMTWdPfkh26HcDns7hN8nXBRWgKDkxn4xtdQXWFCre8jAWeQEdKiG77FQ8p51q5TKdd6e+aUw/YcvJU9zHAoxRRrk/2y0jUT3IfE0Xp+VEzfjAWXySq1inoFG0Vt5lzRHGs4PKRMh2zmSo5nA8VtNbiKxk8GjPTlbyWOxE3NvxUTPuNozKNfIaqFlvTIp3/unjPNvfM7IDSFirU5miqw8dW6SUPChCAOenBZDzJzV6XGwFhgAG+CrwGsK4ULFBAFrvkmkp5k1J30IpJRIoPrMM4pkwei0JZlGDb3rlooKk7shbg2phm95Ljv2/JyttDeWk4shp0Xs9MmZrx2HglF4gbXwivhDnSvvxqxtaYupNHUx/nN7b+rci4bM01gE4WIHv0nNaDtFeV+nHHbB79p/lwgI4kVANKyDTUPvIZGx6/QDeM3PWUafQMs770U/XZz4IQQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(10290500003)(64756008)(66476007)(8676002)(66946007)(2906002)(52536014)(76116006)(54906003)(478600001)(8936002)(66446008)(6506007)(66556008)(9686003)(55016002)(5660300002)(71200400001)(186003)(26005)(122000001)(6636002)(33656002)(4326008)(7696005)(110136005)(316002)(82950400001)(82960400001)(921005)(38100700002)(8990500004)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Y3cuc8tjqCvJonRdWyGhj8Qk9hxa2lgfZL4fuCDJGClMVjcazk/Sxjy7DEAT?=
 =?us-ascii?Q?8oS2jjVmJu3JEXjc3WZJ/CZXbh0a6UJJ8NMmAbxSUhKwFh/V6lZsjN6WwpNw?=
 =?us-ascii?Q?u/Hh57yyvKycXWvLf1dwdUgWGlcW45jlu+n6gMLb3FmxFexsCosG1AbGswi/?=
 =?us-ascii?Q?s5OBCzmJOwYsVB9+iBFWxXN0Y8eFHF8LHRjrVT/z4SO6A72V2YkJAfbFMNQH?=
 =?us-ascii?Q?y78FPmD4wtKG6akTW/NnqiiYBxUHWftKZJOh3dJy1AxSjI+Bz3Dk/mQdIQWa?=
 =?us-ascii?Q?PGr8U16YUDQKgPGUmayIgDUGF+wtXtMdcb1/dpKKe/JMC36Ka65xPlmXSioK?=
 =?us-ascii?Q?eL6s1XzC9yaaw8tGpCMjJD9qgF0Nhr1AeW3EzYipbmmhfmFsL/IsL7tPkyEZ?=
 =?us-ascii?Q?CYm/QlNDTwtqTUfLijyz/k2U6Bs8Uhgu5Gz4jRWmBeQXQm6+8ExvPaCTtge9?=
 =?us-ascii?Q?MOYgiWCFGWhFD1WiZxbeRdKKruOwWY4lMQ+rqwsBKpgcQDB8AqtF/08Urb0t?=
 =?us-ascii?Q?UWYimHyiC1TU2AWw+Imb0JdJIfk2FSORmZJb2PG4C/SfOQf5r80wzSuwePVT?=
 =?us-ascii?Q?liuQVYoIB4jv5mRhpGTW52aPBD/ITeURu15xXl4howg2Kxqjqf5XeBLw4m5I?=
 =?us-ascii?Q?KmuK1UmHweeGvjgn++VZMBbfFO32FIjUXitcDhstAL9J0mJU7LPnK8nd+ZRi?=
 =?us-ascii?Q?4tKd+RvpLthRLegWT0M/2grrbqMxCpAISaMXKnhnQVHwLhmDiMohmeScgGJ1?=
 =?us-ascii?Q?6v0ibeCP3o7+LHFsfoRGlAq18IP6YrjgOUpHfhoMq+ACfj5a29f1dK6Rdks0?=
 =?us-ascii?Q?Z2lSa+JMvUALqxE4Pg6sshDX0fOQPxQcQzXxXhgeFcUqwCAk4/pcsYm1RJtY?=
 =?us-ascii?Q?EKVYFmUqYJNrVSVZvvpUDOXW7fiKXbZMQA1cvNVWWJr+biFfoV8Nm+8UT0+U?=
 =?us-ascii?Q?WkIwJL3/Uh4luS0VOKCkYWwkl9gi3Yv+Axoc22iRtIbthaydJGYWEqhSjk1i?=
 =?us-ascii?Q?G6cOSAxBMXNhXXHmI23qkSL3KXPyqIdf5Qc5urGFzjnfYDVC/2K/L/4teWd3?=
 =?us-ascii?Q?pu/Qt1yg8LvTYnhI6N66FpfKXFAjLvlv+Gua4ruhXoOw3aWPmZ5GXBol38of?=
 =?us-ascii?Q?4NozKhKjyDNZKndSHdtFsOysAEWBlxhivvbLJrLVDd97Q7JxrveP1UI+FlUt?=
 =?us-ascii?Q?Y5CTzApJp6cmvm6IY0dccGGzqklajOkbZt8v10px5hYLu7gNxYjeocDxncBX?=
 =?us-ascii?Q?s60Tm0iVKEhVZvRXhR4xDwCbFORMWTzncBkIMtLQ1eG5h/q4pUbjE7mqPBHC?=
 =?us-ascii?Q?ullnNtnE9z/G0qeEGAnx+2QK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efef7c32-9303-464e-eab7-08d92a9f8538
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2021 17:04:47.0933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8oP70EnOLgMAfL9erZH/3YpVbN7eTxLPWQs50gV5esMveYyhVUAjtQO5qZ7r6CX6GCgEofwZRhXCLej3KrZza4S7SkTp8IutXnw7EEsisng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0906
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vineeth Pillai <viremana@linux.microsoft.com> Sent: Thursday, June 3,=
 2021 8:15 AM
>=20
> Bit 22 of HYPERV_CPUID_FEATURES.EDX is specific to SVM and specifies
> support for enlightened TLB flush. With this enlightenment enabled,
> ASID invalidations flushes only gva->hpa entries. To flush TLB entries
> derived from NPT, hypercalls should be used

Nit:  Isn't this "must be used"?  "Should be used" sounds slightly optional=
,
and I don't think that's the case.

> (HvFlushGuestPhysicalAddressSpace or HvFlushGuestPhysicalAddressList)
>=20
> Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
> ---
>  arch/x86/include/asm/hyperv-tlfs.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hy=
perv-tlfs.h
> index 606f5cc579b2..005bf14d0449 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -133,6 +133,15 @@
>  #define HV_X64_NESTED_GUEST_MAPPING_FLUSH		BIT(18)
>  #define HV_X64_NESTED_MSR_BITMAP			BIT(19)
>=20
> +/*
> + * This is specific to AMD and specifies that enlightened TLB flush is
> + * supported. If guest opts in to this feature, ASID invalidations only
> + * flushes gva -> hpa mapping entries. To flush the TLB entries derived
> + * from NPT, hypercalls should be used (HvFlushGuestPhysicalAddressSpace

Same here regarding "should be used" vs. "must be used".

> + * or HvFlushGuestPhysicalAddressList).
> + */
> +#define HV_X64_NESTED_ENLIGHTENED_TLB			BIT(22)
> +
>  /* HYPERV_CPUID_ISOLATION_CONFIG.EAX bits. */
>  #define HV_PARAVISOR_PRESENT				BIT(0)
>=20
> --
> 2.25.1

Reviewed-by: Michael Kelley <mikelley@microsoft.com>

