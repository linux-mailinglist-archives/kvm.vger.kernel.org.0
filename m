Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 312B470C0BE
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 16:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbjEVON4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 10:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbjEVONz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 10:13:55 -0400
Received: from BN3PR00CU001.outbound.protection.outlook.com (mail-eastus2azon11020019.outbound.protection.outlook.com [52.101.56.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057CFC1;
        Mon, 22 May 2023 07:13:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3/dfgkH4bb+EBzMONdSssKA96Efk0ay79vwIHqzrzSAbjuDGfVxoBZ9bpBFTSwnurDwJdCc6ve9HWiuY7bzuJRUxv2/ljEes4rawfU522Fa6EYpT2sTh8Nv5S6ccKuxsCBYR+Uci0O5ZCoD62i27O0mlrCsnvtmf7iASGR96xGBoG08p/E+0KTh18wQ/3QLlIKMCho2HBHida0vBEe2uIX87dqn3tv75VfWsxeCT8JupHXbKUhYGQVPeip5frJhU/0+8+8al+SflZmXkQjY3neTsImx9nGOaOlmHbwkyDxru9TRBVCvP50pVWJnCX1h/0htsC8mh8xDOF4VTo60rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L5WoZL5JzLzadHPM8ccIoqu2iwVcHGNhSleQjJy7Wis=;
 b=GrcRavPtzt8JmSrMRE+oOGD6eZ4F/VjHSLMPLpm+9Xk8oQkkkMU0fdB9yNaOywcIgPFEY5TyCyOKi6hyTeBGONtx5hzCszivN6IbSHolNfdhmExc7xiCVuKyE6ngoHlE7fWo7G8CNL0u6+kBpk1c8SPzg9eTsqbYd5w5UWiMBS49EGtYzmT7B6BanV9Hv2IgJsOCFWMJ1b9wzEhZdlL4QA5hGrCsIrWySeNU11dWQqP4gpMRkdMHNwNT7P085dpJ8O46TR+wMRZDn8MBA+N7xU5k9eSD/JT0Flr7+bEOA6rL3WMuS50JO9tfDz2cO/hGU7p16ocmn/m7eRbrTKIM/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L5WoZL5JzLzadHPM8ccIoqu2iwVcHGNhSleQjJy7Wis=;
 b=OGVeRPccAQ1/dckqRmGCUn+tt25o6DHLSmhoF09TsHRGh72YxUf4AqBM8bGx5W4MphbWLGX70c/SzkmwywfE6rfqE7Plr/Sq/8kTE30PPfZ8uOzKzrTB1cf1hSbZnnmrK0hvBtCeS3s9G9rnvLflFl/hxrT+lWXLPUUaQaRjPSo=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by MN2PR21MB1519.namprd21.prod.outlook.com (2603:10b6:208:20d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.6; Mon, 22 May
 2023 14:13:50 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::a4f7:2466:97b5:bd31]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::a4f7:2466:97b5:bd31%5]) with mapi id 15.20.6455.004; Mon, 22 May 2023
 14:13:50 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 1/2] x86/hyperv: Fix hyperv_pcpu_input_arg handling when
 CPUs go online/offline
Thread-Topic: [PATCH 1/2] x86/hyperv: Fix hyperv_pcpu_input_arg handling when
 CPUs go online/offline
Thread-Index: AQHZil8FRZ0qOnNN10G7K787DJGg/a9mAb2AgABWn6A=
Date:   Mon, 22 May 2023 14:13:49 +0000
Message-ID: <BYAPR21MB16889F38274F6F7691DB85F8D743A@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1684506832-41392-1-git-send-email-mikelley@microsoft.com>
 <87o7mczqvu.fsf@redhat.com>
In-Reply-To: <87o7mczqvu.fsf@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=388ac709-d9a0-41a4-a05e-1d5b06f894f6;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-05-22T14:06:06Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|MN2PR21MB1519:EE_
x-ms-office365-filtering-correlation-id: 9751bc9b-12f5-48b1-8c0b-08db5acec3e6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0+S5XsQmP2WG5V9XrF51g2T3fNVIXoW2e/nP5+tomQMeNYp5WpAbzjJKYz96y0nkeH26nsb/MPYR3xR83WUyUIUriShM8b7f5+bu25lZg11yegsiUJoupWdl0Gt3b0Q6/rgL3dqbgRXeTFGzI4OVufgUE8ZAr7h5dUPEBz2YONB/GcxupFSfOR9HgNI2BfLtuQmImYZNuYj7loeGmcsZ3BwBL1jedhe0wBBX9XN2w/OUJtf34IZUWQdA7Rg88fkAicr4IrmIcbD+oLKwFEb5n7BQwoB/Hb+1taIazuFnA58epK+Lkq/CIwnfac9v2L6tpyjlG1VEzdg15TCmi8rt6m2Wyy+6LjnPGGPTozJsIk2L9u7slJeKzicAawUniGSZh9eb7KL2EfqcDMbfFVLmuhWHJ/FVyPDXnGY9CZH92q3POVbWsRGiUQHLFM6PXETgO54vuSW9DPc3GKdcJ8/L1BH6gZ1DV5c0j2823IpvRpgOKHfelhHikk3hSBCOGWvvvnMb/dYyWHUMJEsN015A5JeyLcJps8vb1fRItP1LMdnO8RxYz428CK1WbDarvmWKIadQm2TPBKBOrJQiuM1zJuHCc83ccxy0Lx36iWzEQIeo2xXe5K+hqDNgEPD1V+ng/rcclkY5AnzAjbeVQv8bX5Pn25kiBY/ED/mdGwzn5pk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199021)(54906003)(82950400001)(82960400001)(38100700002)(478600001)(10290500003)(4326008)(66946007)(66556008)(66476007)(66446008)(76116006)(64756008)(6916009)(38070700005)(83380400001)(8990500004)(122000001)(71200400001)(2906002)(786003)(316002)(33656002)(186003)(26005)(9686003)(86362001)(6506007)(41300700001)(7696005)(5660300002)(52536014)(8676002)(8936002)(7416002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XfxKJ2mTby+GkXLawOnBznRWbUQekqzcOig1Psah/VJCFVXEvOrrtKCyd/Lt?=
 =?us-ascii?Q?K5zChenygxEo+onvs59Fp7/HLE/xNe8keiuUQsIWzj56qJCTlBr6e109jLjl?=
 =?us-ascii?Q?F3++AIKyCeMaYGGNGGJZr+UbCDfHauOg82/Q1tbxph7+kzvUwix3Y8HYFQGw?=
 =?us-ascii?Q?MRRXpDbrTZxNejXiV28V7VM799FeY12a65HxC9kSVxeugsXGZJqC/rrTHqW5?=
 =?us-ascii?Q?Ug2ugox+2LeuPlAQDb2LzwzQf1DtJl5+3tFqnK4UyY01PwfwONf7FV9nqy88?=
 =?us-ascii?Q?lUvf8++rscS7QxJSkovi92rsKs2mx/eEyi1aQ0kLAh7u4yOgD5tpW2N9kjeW?=
 =?us-ascii?Q?97+E9bDRhiUphxke/3G3utY73qjhMo0K+9VFF+PAqtSbwjIUz7HwOvt/PPIe?=
 =?us-ascii?Q?xIsFFQpoUpA6r4aGOEE+uVAgU2v1MzyJ8HOXUDq/BIRdnYDJj6TKm0whfAfa?=
 =?us-ascii?Q?sdb7ThXfv7d590P8ZRvls+08m56hT8b5lxniXShF4gLNyi+28WIbJAG4h1wT?=
 =?us-ascii?Q?bJBUwPdM0OACmpb43Q4GQBhsal0R5aUpvpdYKy89JS/n54XKWDhL5ohgDUZ7?=
 =?us-ascii?Q?Epy1aXsnKfwZzI2Grl2W+ZJnbB4jynHyzgTPPZS5/PBdzHwyLtVFITJmtwnd?=
 =?us-ascii?Q?U//NlOIf1ZjZ5DdKdikrMkJui+UaG4qjbYjeeLuZKjy5ZgDRMIhgm9r70sqi?=
 =?us-ascii?Q?A6WqAVy1wNVMNacISQvh4FHtLqdZgwZ8JCjYzI7w0MOcxLSE+eZGXxbQUQpO?=
 =?us-ascii?Q?qawXjiMYCXsSvfwE4GypMwGbyBlsKnB8T1MGVA2oznRU4aGo9H7FHSF74Q2q?=
 =?us-ascii?Q?fx8B41C4lP+esuUZ6vIfwOQd2ywLtaM27QsFPnSAckyOYeeZcBPsP09CIIW9?=
 =?us-ascii?Q?l4iOepJ4RpRYTltwdQO0Ns6mX9sYMdxLbOwwqtk3++SUQFpyYJyaNpaeeiYu?=
 =?us-ascii?Q?1ZzX3kVklxu76A8F18fRBLlhN5KvuL65BHLCN3F8y3ssTx4iY5DNuIPNmFn8?=
 =?us-ascii?Q?yGAB4voaOh6fObuXKT/nvN0/gS+R8oiA2PmqIHaGWCUAol3scjyY/Fv5zbKh?=
 =?us-ascii?Q?cpn8BmMP/l7FWIhK65B2z5YUwm9hxmXZW7AtjQUV+G7K3GJVu17Y7D7E1cU2?=
 =?us-ascii?Q?hKQIFSmtL3Ion8imL0GEPzT8f/xc81JrMsVtFy41aBkFp7OLeCMImXjuXCo8?=
 =?us-ascii?Q?nHqP+E0njpkAFiei2v93OXMnLIsl+ndski4henExolOcrP+MeAWBZ/9ZQDuC?=
 =?us-ascii?Q?ZGwn5LFOH9Rf8bd80YhI98YunkdHQ90g1jmynvrEdRn7Rjg5HkrEcAHTecFU?=
 =?us-ascii?Q?FPKAUNUb5MoCQJwHgntdETdV+HcKFlfHe6deV7qT8c6XBVV1FfBfYdrVeSoV?=
 =?us-ascii?Q?CERicwUqM1WsjMEboMQfqxsA5FwiZEgPe2+aUrAje+4Bxz9bIES2Gjnzr74b?=
 =?us-ascii?Q?n/MoNf6DS2b+LNNbSr9KFH8X4/OPNYcTfDsAZ11Uk7YTJLjBIbyuZMJLWdHg?=
 =?us-ascii?Q?awnbyX3ZHl8PNL5dSp7o+OHF99cVpAK+bSbroF+1mr7zSlXDaasqPexSXxHo?=
 =?us-ascii?Q?Hmmd4v0v7mv0H/Gsvlvf4sdwaGAfYdVxmOcRpLsDj38sx9Hkzp/EOawRRU1/?=
 =?us-ascii?Q?ug=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9751bc9b-12f5-48b1-8c0b-08db5acec3e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 14:13:49.8873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H7887uBRJnOJD7XTTtwF4oKq4vgS4pr2iMAflmO7kZNhNXV6EBfJrQ0Wv3bilf2iD1THsR2dgvUIP6VJuf7k7HLMeDu47qNLRaHQ4nW/kwc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1519
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com> Sent: Monday, May 22, 2023 1:5=
6 AM
>=20
> Michael Kelley <mikelley@microsoft.com> writes:
>=20

[snip]

> > diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
> > index 0f1001d..696004a 100644
> > --- a/include/linux/cpuhotplug.h
> > +++ b/include/linux/cpuhotplug.h
> > @@ -201,6 +201,7 @@ enum cpuhp_state {
> >  	/* Online section invoked on the hotplugged CPU from the hotplug thre=
ad */
> >  	CPUHP_AP_ONLINE_IDLE,
> >  	CPUHP_AP_KVM_ONLINE,
> > +	CPUHP_AP_HYPERV_ONLINE,
>=20
> (Cc: KVM)
>=20
> I would very much prefer we swap the order with KVM here: hv_cpu_init()
> allocates and sets vCPU's VP assist page which is used by KVM on
> CPUHP_AP_KVM_ONLINE:
>=20
> kvm_online_cpu() -> __hardware_enable_nolock() ->
> kvm_arch_hardware_enable() -> vmx_hardware_enable():
>=20
>         /*
>          * This can happen if we hot-added a CPU but failed to allocate
>          * VP assist page for it.
>          */
> 	if (kvm_is_using_evmcs() && !hv_get_vp_assist_page(cpu))
> 		return -EFAULT;
>=20
> With the change, this is likely broken.
>=20
> FWIF, KVM also needs current vCPU's VP index (also set by hv_cpu_init())
> through __kvm_x86_vendor_init() -> set_hv_tscchange_cb() call chain but
> this happens upon KVM module load so CPU hotplug ordering should not
> matter as this always happens on a CPU which is already online.
>=20
> Generally, as 'KVM on Hyper-V' is a supported scenario, doing Hyper-V
> init before KVM's (and vice versa on teardown) makes sense.
>=20
> >  	CPUHP_AP_SCHED_WAIT_EMPTY,
> >  	CPUHP_AP_SMPBOOT_THREADS,
> >  	CPUHP_AP_X86_VDSO_VMA_ONLINE,

I have no objection to putting CPUHP_AP_HYPERV_ONLINE first.  I did
not give any consideration to a possible dependency between the two. :-(
But note that in current code, hv_cpu_init() is running on the
CPUHP_AP_ONLINE_DYN state, which is also after KVM.  So this patch
doesn't change the order w.r.t. KVM and the VP assist page.   Are things
already broken for KVM, or is something else happening that makes it
work anyway?

Michael
