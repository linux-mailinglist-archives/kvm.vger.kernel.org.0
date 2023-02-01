Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBF3685C4D
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 01:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbjBAAni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 19:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjBAAnf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 19:43:35 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C24874F872;
        Tue, 31 Jan 2023 16:43:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hy2oApWxJSMSROeuISzKxPHlve8iFsCIPt5porbHXt2cV3fAZAscU1k8Abb+moW4io0xlXV56O36BqWCyUli078uzMWcGrWUO8d+cNsm1ZqiFtcE79zxfs1wth2Cj5lhOdqMaZyiW3I+qiLTPRIMqLKm3MhoGXKvKySGfnprRD3gVU7zF/TaXfLz7Ko3+jBInUO8ZJ1RcpIt3P3eNsDrzzW+aMkq49yYUaMLHSbmrTHabJWCWCpgl6HVMkn4Q/mKa3959tdH9jbWWIqoOzK10nnfl34m4UdIkevAgMc0FuZAMi0NH1ZLzq2Jv7kbltyFff92BgV0fk3eA7ki7EziVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J50HEUP4cZ0cjDdFxWR11ozzL4M13+7ZhfpYZGQoegU=;
 b=KLHlnC0E4pyLEVZPgyAMdluc5vz8/PJ9hrzCRPC29RalaN2XLJY6ygVO5QbssZGXySCEN8bds5yu75vaGutPrWqUHhsoDS4VZjZRxQhzZ31FtjPcRp5VY7bWBi96Vz95rNPibHDxd6sM+Fgq+SAjt2TVN1mcAmdhhuW7uMWRenYGdeA6jqZJHee7nIh2ObWOqVQhKq0q+B+rNNaj7PrtYNJa+WgENYooWWSzoHMPHUfklyzBTFtHz+VbmLPdUBQpyrB8pwb/0EV/iFvCCzdJJzKqWpbfO4MCxDz1VilfRe87VLonVAMEpJJ37IkNHbGD/98DYKrJDo0dLwq5q6WbJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J50HEUP4cZ0cjDdFxWR11ozzL4M13+7ZhfpYZGQoegU=;
 b=Cn7nhwf1dJThOiAoaEW8GU8uSw3IUVJQVI5WRK40u+Zfz9kMqt9W5ZAhW2TL2b4XTbtSJJz4+N/Z8fKXLqfJlVf+qQAyDF7XgdwqmvljTxil5SlgSsIDfoEqgEAnhRUI38Bc4h+wdSrTO2CgsKhACbwnEJe6pOaX5Fwpmg/zb3JBdDQYEEmVX6m0RIlQO+WK4VNjB3Y53w8PnEalta4MuU1mf53FwCs6bxvZi52tL4+d0ovAVIlPsYkDvVK8EtozdO9no/3DfYpLE5JEtNRKZ3Hn06U2l0R5szJ3Ai9o6JbyF+MdvsYGXBkNbrj9r5giY3AMU7GBL1rJDJygvG06Iw==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 00:43:32 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::90c6:a307:66aa:70fc]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::90c6:a307:66aa:70fc%6]) with mapi id 15.20.6002.033; Wed, 1 Feb 2023
 00:43:31 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Zhao Liu <zhao1.liu@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "chao.gao@intel.com" <chao.gao@intel.com>,
        "shaoqin.huang@intel.com" <shaoqin.huang@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v6 3/6] KVM: x86: Reject disabling of MWAIT
 interception when not allowed
Thread-Topic: [RFC PATCH v6 3/6] KVM: x86: Reject disabling of MWAIT
 interception when not allowed
Thread-Index: AQHZLT1AqpfmxLVyw027BAfZpsIhK664f9uAgADRzgA=
Date:   Wed, 1 Feb 2023 00:43:31 +0000
Message-ID: <DM6PR12MB3500CFCE598B8CADCF3262EBCAD19@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <20230121020738.2973-1-kechenl@nvidia.com>
 <20230121020738.2973-4-kechenl@nvidia.com>
 <Y9kFeTG/uwrDpfn5@liuzhao-OptiPlex-7080>
In-Reply-To: <Y9kFeTG/uwrDpfn5@liuzhao-OptiPlex-7080>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3500:EE_|BL3PR12MB6473:EE_
x-ms-office365-filtering-correlation-id: a3d883c7-ac69-442e-901e-08db03ed57c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7mNkgYjngXdbrsRnoEzm8l/IF4bLpGSlkvtT6ah2TNQ4vrM+9WMnzK1LNOzdTNH4EcQRCVRft+mza2MWySLqUyuKiUjse2KSpRZTpBpUrcw6eP11zXAweM2BN22TI3DN+JOClkTUI42wry1mcqjCYZy9HkKjLWiqaB8sluuAds3nmHkEfdLBIaGBWEHfiuqk0CSo5Hwz+lk8d2hl9BAkE2zfH671/KSg20eu0ErzG/lspmWfqpORXVlNcA0uWl6K9C8bUqOYHJZXonH0WKRwtU0Dbaq4ByvMgOKwmmSuPpGI1p5+rxjG+GdeDHaCWma08HuV8hTfRkuj6wyxzHNgBjTUUB+HkJTRQvQqym7jR9pibiVVzCJMs61ekTidBc5Rznly7mAv1Tso7iGX2LAQ0Tync21e3BAoctA+qEe24TL/ZOW4G2C3NRMZOJ9YHymwvsCSbUCh8DjnkiFUpHbeB1bFykZJdybwGCcPeM9AMcoRE5TX1Ipez/fpilzltb/46PP4zxku+TQ3R9Zib4z45pbgjJd8rAwcUKkI12BHA9gfUmCD/fWiDh+LQgL/StDAFqxtqXi0fKY3SA6m46DeEcddyVvE88E/eLdPuPCWFvcjUvCGXNgjeDLJRIUvSVonTJbt/5f5z+hL/Af+5eLPGWKCsjDt4tlB4vELx4cA0epMto8oYjmQ7BQ58+ojhTwrgLn+k5SgVXnFYp6M1WcIrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199018)(26005)(8676002)(66476007)(38070700005)(66446008)(66556008)(64756008)(54906003)(4326008)(66946007)(76116006)(6916009)(316002)(38100700002)(122000001)(53546011)(6506007)(7696005)(186003)(9686003)(83380400001)(71200400001)(55016003)(33656002)(478600001)(52536014)(2906002)(41300700001)(5660300002)(86362001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?okEuDMb+oH6wKOVIvP5V+h5BoE+xQdE+XyBW3DAGVlM//xjth0lfclD4JT3d?=
 =?us-ascii?Q?yhJa0ycuQkmWSFnxxIMAK09WqdPBmZvJJxa3hYtc2SR8mLnj/EaVXwvzF7j5?=
 =?us-ascii?Q?0fniLNPycZe9uSu/DYa7c+sdapSeR2C9auEcORoWvwUJUf2LMNjGTolIwXVQ?=
 =?us-ascii?Q?ez3Tn6DyGoW8JrHpFaaAG8sFulx8NF4Dt9gPgBBIU5eLenWlyD0m2oszPIGG?=
 =?us-ascii?Q?4STckiIR/m/L5LEwj1I0hrEtV2/UEeSBF9OOOtkMuMAdN4eCO5Hszyeo87YU?=
 =?us-ascii?Q?KxErYZaDCFLuVBJjREMbLLpvV/AxWi172u6R9Fc2uQnE+JBm4MnNgwb2/f5C?=
 =?us-ascii?Q?tIirPU/gtG6jI1MKvmFE+ERZod7qX6/3wdJ1GkdVxpS4kva9qxL9xngrySGA?=
 =?us-ascii?Q?fhkBUkq91Vxugc5WFwxSEyg2p2ambm3+4on1jHFl5lOt1rG85BSM8M7rtfCF?=
 =?us-ascii?Q?pweAMHKbntK286BQOS0KQ+WiM0T6cl3mf8ak3Bu3LvO6GAa9FMqbA9bOuZFb?=
 =?us-ascii?Q?C96h+t5zYk8nGG1Q6Az0H37Z7GwQXSFuOaYRFpb6iuRSptxfT/UQeYEOCoVx?=
 =?us-ascii?Q?Es+QAIpP9Z+72Cl7QRCVyyEQUfKQnfBYfPQ3eaCpJ6QrLUtC/678BvlF9wu0?=
 =?us-ascii?Q?/wdwp9Dm0C3vC6pucksVW5kaxIFk+4FZH6k+jldAioSKxCvNPQL+DbATTeHl?=
 =?us-ascii?Q?/kZuI7gtSljZnvPIvpZMtdq1moi54lA5C387MSbFLRr3oR13/uCCo8USBVTE?=
 =?us-ascii?Q?xRfG5c1MsKYapkNud8CqFLOrz82v7zv4CHszj3YFAXFgXjCMaywaRZg/yHUc?=
 =?us-ascii?Q?W06pGCBPGmnRnmug7DDTv/i/XYTzOSa2hc74JI3U9T1QnWiZg8p6SxmpBJb6?=
 =?us-ascii?Q?V8ykdcQRpBuKXEFiU1iUiPgjmfGV2Em9oDJLfU7wFxNVZJs3bGgLabbcPMLS?=
 =?us-ascii?Q?7LSAuahIdBcl9nrz3tJF8UHHFd49LraIqkQ+ufRnbFDMMT5SGlgiCaJvVA4J?=
 =?us-ascii?Q?hmtjj8z4sZFKjHwQP79VgofpsMkgnqhj146BxaadvNbddKqsdMtQiz8H6cuQ?=
 =?us-ascii?Q?vCq7IT7jqeuVQgGKpvVQUV3XCLyTVopoNLsBue8G/MafDuvoGvQBwtEeOhms?=
 =?us-ascii?Q?qJII+aIPUYInBhvmqU2PHb4uE2x1Bcx1BrZtdulyiQvKr2swqySet4BCvBpm?=
 =?us-ascii?Q?Xck9Z5UyIbSHaHu/xwVDePoDgTvaZExk58LqQlaCpC0PicxWUg77lnrNW/e0?=
 =?us-ascii?Q?ETQU8wBVsXDZTHHVATY+HWn/J3X0vbJs+IO9jdDB4g+nmonUQ3Zk2E64VFYh?=
 =?us-ascii?Q?TPuOQfKUOjzQMJLWQe/6qrb6mWwZqodJhsdF2OI/mE9sYC0EwUhykbiisAa7?=
 =?us-ascii?Q?W2n//0KU3hPqRGTAwDH4bHhqpRvArSXO2FIP15JMb7+uclJHW4nyn7x4JgeD?=
 =?us-ascii?Q?lVBGCKZVaFSD9Oo8DWyBwVD85xOpwCPgRsYARHhmjjLP9CxQTpOsdI96214t?=
 =?us-ascii?Q?Fy62XaCUpobRKaZO0WqqNsRWgnWgHDfOoO+3U0aqechxDH0rfpJFpiXLHi4u?=
 =?us-ascii?Q?sFOc9jyx4t9O5+KCB2UmYxQxA+xF5a+rKZN6p34O?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3d883c7-ac69-442e-901e-08db03ed57c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2023 00:43:31.7392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CMoHS2C4+b3YRj2xhekrvcpHIx2oPzoMDmIIcl1wRzG4oBj+/d4/zJviLcDSPrnkqHcTNyNSjsC4B4FyI/IRSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6473
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zhao,

> -----Original Message-----
> From: Zhao Liu <zhao1.liu@linux.intel.com>
> Sent: Tuesday, January 31, 2023 4:12 AM
> To: Kechen Lu <kechenl@nvidia.com>
> Cc: kvm@vger.kernel.org; seanjc@google.com; pbonzini@redhat.com;
> zhi.wang.linux@gmail.com; chao.gao@intel.com; shaoqin.huang@intel.com;
> vkuznets@redhat.com; linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH v6 3/6] KVM: x86: Reject disabling of MWAIT
> interception when not allowed
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Sat, Jan 21, 2023 at 02:07:35AM +0000, Kechen Lu wrote:
> > Date: Sat, 21 Jan 2023 02:07:35 +0000
> > From: Kechen Lu <kechenl@nvidia.com>
> > Subject: [RFC PATCH v6 3/6] KVM: x86: Reject disabling of MWAIT
> > interception when not allowed
> > X-Mailer: git-send-email 2.34.1
> >
> > From: Sean Christopherson <seanjc@google.com>
> >
> > Reject KVM_CAP_X86_DISABLE_EXITS if userspace attempts to disable
> > MWAIT exits and KVM previously reported (via KVM_CHECK_EXTENSION)
> that
> > MWAIT is not allowed in guest, e.g. because it's not supported or the
> > CPU doesn't have an aways-running
>=20
> nit: always-running?

Ack. Thanks.

BR,
Kechen

>=20
> > APIC timer.
> >
> > Fixes: 4d5422cea3b6 ("KVM: X86: Provide a capability to disable MWAIT
> > intercepts")
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Kechen Lu <kechenl@nvidia.com>
> > ---
> >  arch/x86/kvm/x86.c | 20 +++++++++++++-------
> >  1 file changed, 13 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c index
> > 9a77b55142c6..60caa3fd40e5 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -4326,6 +4326,16 @@ static inline bool
> kvm_can_mwait_in_guest(void)
> >               boot_cpu_has(X86_FEATURE_ARAT);  }
> >
> > +static u64 kvm_get_allowed_disable_exits(void)
> > +{
> > +     u64 r =3D KVM_X86_DISABLE_VALID_EXITS;
> > +
> > +     if (!kvm_can_mwait_in_guest())
> > +             r &=3D ~KVM_X86_DISABLE_EXITS_MWAIT;
> > +
> > +     return r;
> > +}
> > +
> >  static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
> >                                           struct kvm_cpuid2 __user
> > *cpuid_arg)  { @@ -4448,10 +4458,7 @@ int
> > kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >               r =3D KVM_CLOCK_VALID_FLAGS;
> >               break;
> >       case KVM_CAP_X86_DISABLE_EXITS:
> > -             r |=3D  KVM_X86_DISABLE_EXITS_HLT |
> KVM_X86_DISABLE_EXITS_PAUSE |
> > -                   KVM_X86_DISABLE_EXITS_CSTATE;
> > -             if(kvm_can_mwait_in_guest())
> > -                     r |=3D KVM_X86_DISABLE_EXITS_MWAIT;
> > +             r |=3D kvm_get_allowed_disable_exits();
> >               break;
> >       case KVM_CAP_X86_SMM:
> >               if (!IS_ENABLED(CONFIG_KVM_SMM)) @@ -6224,15 +6231,14 @@
> > int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >               break;
> >       case KVM_CAP_X86_DISABLE_EXITS:
> >               r =3D -EINVAL;
> > -             if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
> > +             if (cap->args[0] & ~kvm_get_allowed_disable_exits())
> >                       break;
> >
> >               mutex_lock(&kvm->lock);
> >               if (kvm->created_vcpus)
> >                       goto disable_exits_unlock;
> >
> > -             if ((cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT) &&
> > -                     kvm_can_mwait_in_guest())
> > +             if (cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT)
> >                       kvm->arch.mwait_in_guest =3D true;
> >               if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
> >                       kvm->arch.hlt_in_guest =3D true;
> > --
> > 2.34.1
> >
