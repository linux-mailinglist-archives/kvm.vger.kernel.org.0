Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE73D6D9FDA
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 20:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240173AbjDFSax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 14:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjDFSaw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 14:30:52 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D359C618B;
        Thu,  6 Apr 2023 11:30:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQovqOQTREdhhx5HFhai13zVw4kDuXP0c4GRLZGZQeqjjHngCs4FoKpXzdsTXLG5KLsitJnIeyj+o4n7PSB3/4iRzh7rTIsEMTNmL4idvRUo8H+gpubWU2lBURg4x1lPAuYlUJMDpzVcMwnJFlTx2GuGs2MMm44MhbqVL0kJa/32FaWUkqqwho2Ea2MFqNWYReFP/KmcTpvT0sTwy8hlAyXrFLmL9lzDqV1A0MyUXCF5yRbdMWWRFdG0tpePW7HY2NttkSbgsbvXvVGy3Z1Xh/Zu20aHS0wpOgYq3wJWWLX3RLTZ6pX3bTRyMKt+7g0xQ8kqh0ycXHo8uje8ow0lNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8mU4RkxZA+2mpcr7TzFZ1FRbc6jKLtCTnnNpTzMX9Ec=;
 b=SOOUOcGbke1rPa7jRXlhbwDxGq56rg8EU4qw9FQn2WBMQKVCRvNIEMxVMCqEc3A+lOOBEvuBzW8Iw3eA0p58mOIRZ57Gcj87x0QseG+AHmT/cbaSej7HKnIgNK0oyiNJUKJ+n4/y42fhgZDYGNre9XnW3s8vO52B7qZ5hQHJAPtNokX45uBNNWsjN+A7t5IpcyzdMrKJ1Z518ywwEGixuSojTsCcM/R0FWgIHDVFSclxzddPjlZ9gzKdnr/Ymvgiu5EKfkFEoJ7tNlovLeYU7Ng9h9KipVbHtWBntrl+dV3LkGUJ8iKVroVSoerEql4IdlItiwZUkm7mW8xtILgd6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mU4RkxZA+2mpcr7TzFZ1FRbc6jKLtCTnnNpTzMX9Ec=;
 b=EyxOAyCl9m2vE3CAlMCTizGr78RpBQkfi08RUyzGvEV1S+KdLpUcsWVbcEX8EQoofase0RcNdhi91MMlZ0CcOZXDMvNg4W9dip+rbx1QEUmLRXqeMZZDWeLyMZxYtaxPe7phj8iQWHngmCQc0p8NTJocM0jOg0WGQLuE8vUcivO3J965mFfMBSJJ7IvygKV3hBruLWJNG1ahsn6zSHxDhkxCncEdMXiFj1AZ1y8xMaJR2qk/BGgum/LHKOBkSbHRrENDO+nbRYrrWYnTMCoIjmaz0SVIKDdFhcZSirAE4JvN97NbmMKsF8Nht+7snHo8TbwaLk0c2O+9WD1JMm277Q==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by CH0PR12MB5187.namprd12.prod.outlook.com (2603:10b6:610:ba::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Thu, 6 Apr
 2023 18:30:48 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::7021:4170:72a6:2f40]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::7021:4170:72a6:2f40%6]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 18:30:48 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] KVM: x86: Don't update KVM PV feature CPUID during
 vCPU running
Thread-Topic: [PATCH 2/3] KVM: x86: Don't update KVM PV feature CPUID during
 vCPU running
Thread-Index: AQHZaDf/eErRJOeib02FFy8Nk5+Juq8ekZdg
Date:   Thu, 6 Apr 2023 18:30:47 +0000
Message-ID: <DM6PR12MB350040DC6D888AA660EFE0DFCA919@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <9227068821b275ac547eb2ede09ec65d2281fe07.1680179693.git.houwenlong.hwl@antgroup.com>
 <9fbf5b4022d67157d6305bc1811f36d9096c26fc.1680179693.git.houwenlong.hwl@antgroup.com>
 <ZC48lSLO417emh/E@google.com>
In-Reply-To: <ZC48lSLO417emh/E@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3500:EE_|CH0PR12MB5187:EE_
x-ms-office365-filtering-correlation-id: 8767cdc8-b5f8-49f2-5f21-08db36cd0ac1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7boZJts8tucJ5Bws5j0bXsf2t9W8UF15N6BoSxPzWVbruUMZzAVseZ+CZztlnFXYPib281IUIN0KptmtiA6cQlU+N6YEvWxQeiKjVELWv+2ooVY3InwKdu4/WY0o5d11Ag+Tv2VKAe5c2IK5POpTFahQ+bpDIM5BJM/oPE97nN8/v4if1YTd5opJ6dC2RBkdDsrl8xCiMYNlEDOJ4WhFxKpKxrDhBTyurrdO0/ZJB3YQ8//ZmFJSJ989NMsbaW3f73uHLRdVyXCl1WoxXD36ao6U13Tri41cxItc41a5yhhrVQiV/k/5EDQxbWbVK8EXYPCHh3mBCzaO8s+dhCd9vVOFRc9WXvv67kvcDwKZ3SuMDtuT+AIDLUUA/Z/YOdsR1zhHEqFjBISZypdGJnRQPNoRHQ9harwcBEypViOrx2CM+9lzXSrDlt1+2EM/fREri+U9FnGmyoTmftr2NfMwnhVRIoYpxVQdwphcpHCjO5Wk9yydg6AxvFON3tLSEYV26e2La/zEv0j7iLM3Xr+KQn2V1w2tOME3/n07kvj4BeVFa4be4/G1jocEN4weHzZaiKl1K6lvhi1p7IMrO2/RAH5QsozdSvv5yzMGlkjwwfTe86dnzFDvEooA8K9kb5KYgbE0INwzmvrZgoW2Jll5Ig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(451199021)(66899021)(33656002)(38100700002)(2906002)(5660300002)(4326008)(15650500001)(7416002)(38070700005)(55016003)(8936002)(52536014)(8676002)(122000001)(64756008)(86362001)(41300700001)(66556008)(66446008)(76116006)(66946007)(66476007)(966005)(83380400001)(9686003)(26005)(110136005)(6506007)(54906003)(53546011)(186003)(478600001)(316002)(71200400001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?of9M1x7uQOATFwduJsl+QbBz9DcVR4/ImAfIks6lI+5XEXEcJ/Pwl1Nj+kw7?=
 =?us-ascii?Q?Ewz7drdlxgmbmXzuxF/OtrioTywhuFSO37CJHvZBJDN/kQjjd/cTgq/FZBwO?=
 =?us-ascii?Q?K3oiHDdAW8B4QvXRfd5Bi/ODwqQ0N91MyQNI3vOJ9xC0o59TvzLYUi4lhIab?=
 =?us-ascii?Q?nZyFxr0ko3Ks+ZhNsswMAQURtoJZzkcz0KHLyLFVJNE/fbqBjH6PLAQqi1/Y?=
 =?us-ascii?Q?0fEvC+Jw73DlIwuivN5MNoWtXXl/dwG2TVjFZRrPvo5q+ZqBF4UlvEddBGNN?=
 =?us-ascii?Q?3hIL0jMe96axoWUwsj7IO52wqjmlw1seFOf/shw8z8d/FS1OUvrq3thki/Xf?=
 =?us-ascii?Q?IolSdgwSCzD0hI+F71hP8ZbhVPjuQ6GAquq+WBcSfHz1mG3jSGKcK1ZJzQ7E?=
 =?us-ascii?Q?AoKeHpTd11TZM1uwUj2mNcTAvEDAKtB4zcOw2bRINOw7c9DdDv5ABNTWedgh?=
 =?us-ascii?Q?H+7y221dxA8uh1tA2g/kw6MfxUVHaXY4FWfx1OtzR3E6TdKFaHJYsMpEraW1?=
 =?us-ascii?Q?vFjy/DBS9WVwBrraABUTom9YTqNd0H33lI9qwEvM7WrnMfAP/LH4UYarzlM0?=
 =?us-ascii?Q?0HfdgNUXS4l0fPaf1988+hr/XM8VIsSiN94Wudguom6Jy4U7ah1OlKiNLEFY?=
 =?us-ascii?Q?tkCL81e08p0/T/EfOYIYplG9AhCaswds1ml/KzNnbUt7TChdh7MnQAYXT0rl?=
 =?us-ascii?Q?TBvsbfFvtVIDQ93CbRatmvgiPSNxr4ef6f1kgAXRkGweWdxH+sdVI6DjkFBT?=
 =?us-ascii?Q?VJ0rAXaQC6MmCy1czSTFSmy5V1+0dx3trRNwk9YOgBQY/rh+eLalaX/86X2T?=
 =?us-ascii?Q?nAQGfNShCbcLSDD93B5R+3fcANU3oTzyo+zqj16LklXYLFMqufgA3vz1I/tF?=
 =?us-ascii?Q?xEnF9luikZ1k+mM/KhmF9iq+zbBJP9p9B5G+0dTq0wMcCLAtuF+y363EsrBR?=
 =?us-ascii?Q?idFEOWFaezv2uwFFR2gVp6JxxDU5RXvsw1ykrOjk2CqlXPXsl2nTuyIl4sEs?=
 =?us-ascii?Q?arABFrP1RnctuGrir+XcCFBAllO8juO8Dw6A83nNLbDJVc+sdv6iy21ZJoyB?=
 =?us-ascii?Q?xT4SQAKwOWyBlVIMtDK1+DVGmnqA0kpxAw8NFFjdq7jbfij21IlgoxyGeWAW?=
 =?us-ascii?Q?7eoJr8QMjMwzNgQaomTdvVVih/aI+ByaZ1Gni1XNTr/pROhTW3Q+cMq7buDw?=
 =?us-ascii?Q?L61i0pg+w4/kI4AK5+B3EIr/3i0dtkdx2qXEYm45yNI4ZQ0O53kF4zMmEjWg?=
 =?us-ascii?Q?jmlYYPzxDYDjCTpaZY2NZRr1pVzttD4WI50qOP1WE96NRLQIzBrhysdTvrey?=
 =?us-ascii?Q?TQjq0jEE53Kg5Hhr0t4rMBQ1Nr7srAhm/ISatRy+b31djrweXgiQRIZbLZdG?=
 =?us-ascii?Q?zGgBBiDgGc7VZrRRNEm4U8ytvsVYlP5mKTMhGZr1RHkXuLLFxrrqolXlni28?=
 =?us-ascii?Q?NLB4rBRUbPVHf2j1k3MryfvV3qrDp39GLw/4/uORjUqwUyNrCLHvwwsqXpOj?=
 =?us-ascii?Q?T5LW1m1ThqcDOEMAL+BQ52g87MDqczzvxFjtXaGPpCQl8LbOnLe6rjUcx/Ek?=
 =?us-ascii?Q?raN0lAszKX5u3/rzFAa0A0n30lCqt3lkHunEjqBR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8767cdc8-b5f8-49f2-5f21-08db36cd0ac1
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2023 18:30:47.9678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4blUyYQ+W3t32q0L/H/fZSTPuSoYjP/GdAuycmtBJkcnya24vrRQfrkBoG0cOZTkvz8M3X208BdYBAe93LUnaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5187
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Wednesday, April 5, 2023 8:29 PM
> To: Hou Wenlong <houwenlong.hwl@antgroup.com>
> Cc: kvm@vger.kernel.org; Paolo Bonzini <pbonzini@redhat.com>; Thomas
> Gleixner <tglx@linutronix.de>; Ingo Molnar <mingo@redhat.com>; Borislav
> Petkov <bp@alien8.de>; Dave Hansen <dave.hansen@linux.intel.com>;
> x86@kernel.org; H. Peter Anvin <hpa@zytor.com>; linux-
> kernel@vger.kernel.org; Kechen Lu <kechenl@nvidia.com>
> Subject: Re: [PATCH 2/3] KVM: x86: Don't update KVM PV feature CPUID
> during vCPU running
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> +Kechen
>=20
> On Thu, Mar 30, 2023, Hou Wenlong wrote:
> > __kvm_update_cpuid_runtime() may be called during vCPU running and
> KVM
> > PV feature CPUID is updated too. But the cached KVM PV feature bitmap
> > is not updated. Actually, KVM PV feature CPUID shouldn't be updated,
> > otherwise, KVM PV feature would be broken in guest. Currently, only
> > KVM_FEATURE_PV_UNHALT is updated, and it's impossible after disallow
> > disable HLT exits. However, KVM PV feature CPUID should be updated
> > only in KVM_SET_CPUID{,2} ioctl.
> >
> > Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 17 ++++++++++++-----
> >  1 file changed, 12 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c index
> > 6972e0be60fa..af92d3422c79 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -222,6 +222,17 @@ static struct kvm_cpuid_entry2
> *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcp
> >                                            vcpu->arch.cpuid_nent);  }
> >
> > +static void kvm_update_pv_cpuid(struct kvm_vcpu *vcpu, struct
> kvm_cpuid_entry2 *entries,
> > +                             int nent) {
> > +     struct kvm_cpuid_entry2 *best;
> > +
> > +     best =3D __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
> > +     if (kvm_hlt_in_guest(vcpu->kvm) && best &&
> > +             (best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
> > +             best->eax &=3D ~(1 << KVM_FEATURE_PV_UNHALT); }
> > +
> >  void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)  {
> >       struct kvm_cpuid_entry2 *best =3D
> > kvm_find_kvm_cpuid_features(vcpu);
> > @@ -280,11 +291,6 @@ static void __kvm_update_cpuid_runtime(struct
> kvm_vcpu *vcpu, struct kvm_cpuid_e
> >                    cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
> >               best->ebx =3D xstate_required_size(vcpu->arch.xcr0, true)=
;
> >
> > -     best =3D __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
> > -     if (kvm_hlt_in_guest(vcpu->kvm) && best &&
> > -             (best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
> > -             best->eax &=3D ~(1 << KVM_FEATURE_PV_UNHALT);
> > -
> >       if (!kvm_check_has_quirk(vcpu->kvm,
> KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
> >               best =3D cpuid_entry2_find(entries, nent, 0x1,
> KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> >               if (best)
> > @@ -402,6 +408,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu,
> struct kvm_cpuid_entry2 *e2,
> >       int r;
> >
> >       __kvm_update_cpuid_runtime(vcpu, e2, nent);
> > +     kvm_update_pv_cpuid(vcpu, e2, nent);
>=20
> Hrm, this will silently conflict with the proposed per-vCPU controls[*].
> Though arguably that patch is buggy and "needs" to toggle PV_UNHALT
> when userspace messes with HLT passthrough.  But that doesn't really make
> sense either because no guest will react kindly to
> KVM_FEATURE_PV_UNHALT disappearing.

Yes agree, toggling PV_UNHALT with per-vCPU control also sounds not making=
=20
sense to me. And as pv feature is per VM bases, if current per-vCPU control=
=20
touches the pv feature toggling, that would probably cause a lot of messes.

>=20
> I really wish this code didn't exist, i.e. that KVM let/forced userspace =
deal
> with correctly defining guest CPUID.
>=20
> Kechen, is it feasible for your userspace to clear PV_UNHALT when it (mig=
ht)
> use the per-vCPU control?  I.e. can KVM do as this series proposes and
> update guest CPUID only on KVM_SET_CPUID{2}?  Dropping the behavior for
> the per-VM control is probably not an option as I gotta assume that'd bre=
ak
> userspace, but I would really like to avoid carrying that over to the per=
-vCPU
> control, which would get quite messy and probably can't work anyways.

Yes, in our use cases, it's feasible to clear PV_UNHALT while using the=20
per-vCPU control. I think it makes sense on userspace responsibility to cle=
ar=20
the PV_UNHALT bits while trying to use the per-vCPU control for hlt passthr=
ough.
We may add notes/requirement after this line of doc=20
Documentation/virt/kvm/api.rst:
"Do not enable KVM_FEATURE_PV_UNHALT if you disable HLT exits."

Best Regards,
Kechen

>=20
> [*] https://lkml.kernel.org/r/20230121020738.2973-6-kechenl%40nvidia.com
