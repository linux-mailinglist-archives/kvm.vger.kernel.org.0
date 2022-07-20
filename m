Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2BB57BE3C
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 21:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbiGTTFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 15:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiGTTFA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 15:05:00 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB17455092;
        Wed, 20 Jul 2022 12:04:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mt5DG4CXU+5fIK9hwD/CFxga+ffqwZYuYxLs2ZrZHy/RwVi9zxn2Uyi82RpOisk2otVNQ4QVdiZJk07z/Fg7i+y75uwl/fcb+BC2QLnwvaMAzWy2yjlzwPNAf9GlWQe28VXJyjItLj3he9sdjJb/Ld7rYrG+jpF6haLAqevvhWZmj8qoNG2e2yb7d9bdVCIraheW4JSy+KNP8gp7a4LTmH/hEJDGHkyxd1ENDPUV65rWJSEKcNG++OmF41RsFB4y7o8IwaxCGf3RQGOu9vWdkiGYQ70v44wgsiS/dnIRkXftes7aLTP84qn4Ipc9EJ/4VSEwot2HczoBd2gm4sFTgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nrrmpNGymONgtsSG4HdF+53DYsnhFj/ERygUWhgvUZQ=;
 b=jKuWRFDd1MqzQbKbAzT4k5BOsUap2y8Lns0EiGm0CkWQXkav++ieanSlMK3KbIuHN1ZEu2dECVhfAitVqqlq4wTy1O7CyC5lZef86OARMphIvIPJuLf/JovSX9XGTsbZMl+JGzPDYYKyvLZ+9PrTUJpCpVqv3WJT3DVLi7ghYOO3VFzKzp6vePKkSXZs1tm+cKuoVib4IusGbwtp0IBeBjdgjRt+EkS8OCMyco3VA4jGHAe4pYiD+zZTbpkevWOiMK7xzTrenW40FDpZw5ITl1QLtoKC4gbd+L5kcoKOBaZVj6q+YMrkLonmecjzRRjj6PX3ESIzxL7VCywQicWjhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nrrmpNGymONgtsSG4HdF+53DYsnhFj/ERygUWhgvUZQ=;
 b=InDDcX4rsiqdVjnOWLG1UTC7tVlJqeh1kDtpAv32uwexCkdLubJmSiJqK5smvtWZkdY4nwGFMnhdZEWQDAip5CRtZ158yOpY5eNRKxn9j8KCsZ5GeT5stFCVV8GIcYmWtIKd79SuaEIAbolM6ehyFRjf8p/tJ3kyVVQ80nzv3YDffh8RsP03UT5DsDn5agf+9qlL0l+7ZPHk6bnPATUD1H9VUou64QJJ0Cg9nRPHP8vYYqNjnHBkwf6x0CBXEAj1kEbRZUiKQv3j9axSqALKjOsULrUVXe+U+z2Pj3ZtYRLrxcunruPZmUC21Pw2ege3/CJp6L/vW285wRIP2abDIQ==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by BN8PR12MB3059.namprd12.prod.outlook.com (2603:10b6:408:42::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Wed, 20 Jul
 2022 19:04:56 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9479:3bdd:517e:1d54]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9479:3bdd:517e:1d54%5]) with mapi id 15.20.5438.023; Wed, 20 Jul 2022
 19:04:56 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "chao.gao@intel.com" <chao.gao@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        Somdutta Roy <somduttar@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v4 5/7] KVM: x86: add vCPU scoped toggling for
 disabled exits
Thread-Topic: [RFC PATCH v4 5/7] KVM: x86: add vCPU scoped toggling for
 disabled exits
Thread-Index: AQHYhdK9C+0dszRonECIz3pzVsNAb62HxQ8AgAADOIA=
Date:   Wed, 20 Jul 2022 19:04:56 +0000
Message-ID: <DM6PR12MB35008628D97A59AA302E772FCA8E9@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <20220622004924.155191-1-kechenl@nvidia.com>
 <20220622004924.155191-6-kechenl@nvidia.com> <YthMZvWpZ+3gNUhM@google.com>
In-Reply-To: <YthMZvWpZ+3gNUhM@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9bbbdece-caac-4d70-5d38-08da6a82bc5a
x-ms-traffictypediagnostic: BN8PR12MB3059:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9ci4rhpf5HLyEK8GaKfeICkl/kmUlvjsK+XVKPekb3w9wsXXC1FyEARfF8FJ4S99a0ELgzRjpvJ92mwezo3YrFPHzvtLU+gFRHpmRnLihJ5uurBJsEbyGDhyg41es+ngL97JFbAwvHy+Ok0WE7LeuvTRGMYXFaqYQl/pjaD8CjkxNYC6DBIbnTXag6IrkaCRD/twNWJ4x0o5tAD4KkJBaqIUFIRgXEl39BXYUaAIM8utm3vPLMDltQfngsUIN7t4CIGbTpCJap5SsRNSZJrOTLTXpR6yEUch6QI02dlhcS0Uqv00zl7C5b1wfz8mmzzwT8fish8q33fLUIlyGTg/Oja1+4KeEzbnaNd3Tu5cfhuA9hIeSAuDQhUanQPTqkHKdD+LiKgHftA79g35ihkRK0TDX6Fzrx16gQuPChWOxiUZLNIymbLo4V85sZlZFSzzQup4U6tUpY57mMIkH4/yZhc/2d+PnYKXqJAwdVACEaXiBXvMfm4x3JVzUHCbUQYEaMpoy6pP/4NbO9elrwuJ033A6DnPyITprLcVbpOT8TM7rZtqqoLgyws1O+yiz2MUNEIpcxYJENeqRmpTl3gDmquxYXxui5WgsaglTOBVVt7BaP75fqtYPQ6AJ98Wxa8eM/A3r4Yz2oASuWYM2rvv+rLvM8dl0rCII4qckxQ7Fi5yg6i4a4R8etYd8dCbwBcWxA7/z2UmVHCey96MlLih93caK5LDEhn8DOwGAA/D3ZoREAN59REQ92hNyTLNzy7FgUuhOoEIN0B6k7M3ihZEGsNgguLeYeAxD9zie0HRo2zSs1z6A96jbxfEjvYPdMUV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(52536014)(33656002)(8936002)(55016003)(54906003)(5660300002)(6916009)(4326008)(86362001)(2906002)(8676002)(66476007)(66556008)(76116006)(478600001)(122000001)(71200400001)(38100700002)(66446008)(6506007)(7696005)(26005)(316002)(9686003)(53546011)(186003)(83380400001)(41300700001)(38070700005)(64756008)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6n1BaEp7XhHH0Ipmr0f6clF202mP3qDCUvPbvZbU/wDVuwMAiSC026jsezMB?=
 =?us-ascii?Q?TwBV2YMGqzC4DTjx1e9TqyD47vSVYsKykbflTmHxZo6f/YA6lBTup/Wp7afm?=
 =?us-ascii?Q?5xz2FTaKTKguzIbnJS/R15Iizh4Y84RRgyBRDxMu2gkvLVKgJ7zACUicY85n?=
 =?us-ascii?Q?qfmu9RSaDRyUh81NxBqqScpzFI6OFCekcQknWntJiutcCc7d1cwybFUs5HVr?=
 =?us-ascii?Q?j2T2LiheBqm9EoUJKKVe2dX43AyAEOZipYCi9hpQY0ioobyJdKhbUvSObdOD?=
 =?us-ascii?Q?T9VxOHHxCxCa/+EGOmho5TjrVYEKkK0gbMpiOe85N4IRs9JeKyKCSDstB2L+?=
 =?us-ascii?Q?rPP4evbrnzPPLis822Q30sCLrekG9n29G+qkMmg2uI6iWnK7yeOqG0PqpIYl?=
 =?us-ascii?Q?DVmY7ZQf1P74ddgaagUsTn3CzIvf+OUUyfcehLhAlZYqsdxttxentO+U12nM?=
 =?us-ascii?Q?55ioFWtM85YhqyVFN+yF3yXDqg7YULUrK28WMoe+I6HyR4RyKbjJSrxe5gsH?=
 =?us-ascii?Q?5M2aO/j5X8B2klgtYjJdR54Y8wDDljzKMa25qJpL2ggE13PEIbLELSmBkDkL?=
 =?us-ascii?Q?Epfbt/ukC2AIcyKH4FZ/t/5WjFIoKxcOHntiwZS0DltfYGvozAB1TqiFETrU?=
 =?us-ascii?Q?gkYEB3kXxDUhH4aueZ1h/c9YGdZ1edbgX5dZEGnsurq4USAVodHu80d3wtj3?=
 =?us-ascii?Q?5WH5G3g5Ye41oVM3m2K2UayK0yoFZBCBFo0ZevJOiMDRg3mVWh38NqQWD4ls?=
 =?us-ascii?Q?RgiOuR5zNS4IFhfmBFb030sM58JnlMf/mAJxH2odJtXbPyXD4KneaJwtRk3a?=
 =?us-ascii?Q?Xnlj4lKFeQhMdSo8ID0OthUTRqUaNFv6Vm49U+YMlnynyHF4mR2H/bwuP+uD?=
 =?us-ascii?Q?Ac8EeJYWLkqkTS8e3GoUCpir9CI/mfEUHUQ6Jx99W2G8T17x7OzGH36/lsf0?=
 =?us-ascii?Q?StP4pQG+B9b0JE58SMPQqaHjovix9iHBXrkufWjR/uRpF13dCEIQed6z5Mx/?=
 =?us-ascii?Q?shQkGN0/fMWA/a4G1Ag1nxP9N6KgXq923kD+n593LMZcsbVJmdLGFbxgQP8A?=
 =?us-ascii?Q?pADZa3/N0FL87b0mPUKFGy4BjMmNkPpbRrUE5DfYGik8iyLF3YoLqqRRrlwP?=
 =?us-ascii?Q?8vffPSYpju7dVhaVYl7XelvkY7sNqf4AIcPS/F+TNX2GDenYIQr8ucOV0EwO?=
 =?us-ascii?Q?AV2n40P8d6/XugoWvruIgN/hZa36moF/7J4PkTl32xB50Jqf9SqSXUamdFGr?=
 =?us-ascii?Q?hO7WgOczrj/chIJtj4QIfKA8s3V2LB7XTg0pLNCYm0tHUbwax2HknVU1cqAr?=
 =?us-ascii?Q?Ci/VHSaJ7WQ65cCGaLfKno6wo+7uXvkRfVIJAL0rPC8dIn8YnNSrfluosZPT?=
 =?us-ascii?Q?iCON70u/dqcgjuQKdgb4izy8JBp2D4Wz1O8sIMgCV5AOkBPPKMBH1PwP9Toa?=
 =?us-ascii?Q?wPiZ/Qrs5Urg/R8AM/QdiNGUaydJT+tY7uSmDML8a+m5+/VA0/vnMqyt0Eh7?=
 =?us-ascii?Q?N+mJlUGMLrj+cOzqANbDgLxfO5fJdonyDAGuuzfk5+IiBOQ9HqkK1tRc3DTN?=
 =?us-ascii?Q?999yurH7zfO5yOBuFUQ43GLSDRvDxF9mpv1Qm0Yn?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bbbdece-caac-4d70-5d38-08da6a82bc5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2022 19:04:56.4209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fLX/VL73c92zxAYY/Cl2V1RN8JYGbRzVIQJngCLoSZXmmGflwUeF3k7o67ALufHxXczjlS8WbjRga4h/9RecVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3059
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Wednesday, July 20, 2022 11:42 AM
> To: Kechen Lu <kechenl@nvidia.com>
> Cc: kvm@vger.kernel.org; pbonzini@redhat.com; chao.gao@intel.com;
> vkuznets@redhat.com; Somdutta Roy <somduttar@nvidia.com>; linux-
> kernel@vger.kernel.org
> Subject: Re: [RFC PATCH v4 5/7] KVM: x86: add vCPU scoped toggling for
> disabled exits
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Tue, Jun 21, 2022, Kechen Lu wrote:
> > @@ -5980,6 +5987,8 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm,
> > struct kvm_irq_level *irq_event,  int kvm_vm_ioctl_enable_cap(struct kv=
m
> *kvm,
> >                           struct kvm_enable_cap *cap)  {
> > +     struct kvm_vcpu *vcpu;
> > +     unsigned long i;
> >       int r;
> >
> >       if (cap->flags)
> > @@ -6036,14 +6045,17 @@ int kvm_vm_ioctl_enable_cap(struct kvm
> *kvm,
> >                       break;
> >
> >               mutex_lock(&kvm->lock);
> > -             if (kvm->created_vcpus)
> > -                     goto disable_exits_unlock;
> > +             if (kvm->created_vcpus) {
>=20
> I retract my comment about using a request, I got ahead of myself.
>=20
> Don't update vCPUs, the whole point of adding the !kvm->created_vcpus
> check was to avoid having to update vCPUs when the per-VM behavior
> changed.
>=20
> In other words, keep the restriction and drop the request.
>=20

I see. If we keep the restriction here and not updating vCPUs when kvm->cre=
ated_vcpus is true, the per-VM and per-vCPU assumption would be different h=
ere? Not sure if I understand right:
For per-VM, we assume the per-VM cap enabling is only before vcpus creation=
. For per-vCPU cap enabling, we are able to toggle the disabled exits runti=
me.

If I understand correctly, this also makes sense though.

BR,
Kechen

> > +                     kvm_for_each_vcpu(i, vcpu, kvm) {
> > +                             kvm_ioctl_disable_exits(vcpu->arch, cap->=
args[0]);
> > +                             kvm_make_request(KVM_REQ_DISABLE_EXITS, v=
cpu);
> > +                     }
> > +             }
> > +             mutex_unlock(&kvm->lock);
> >
> >               kvm_ioctl_disable_exits(kvm->arch, cap->args[0]);
> >
> >               r =3D 0;
> > -disable_exits_unlock:
> > -             mutex_unlock(&kvm->lock);
> >               break;
> >       case KVM_CAP_MSR_PLATFORM_INFO:
> >               kvm->arch.guest_can_read_msr_platform_info =3D
> > cap->args[0]; @@ -10175,6 +10187,9 @@ static int
> > vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >
> >               if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING,
> vcpu))
> >
> > static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
> > +
> > +             if (kvm_check_request(KVM_REQ_DISABLE_EXITS, vcpu))
> > +
> > + static_call(kvm_x86_update_disabled_exits)(vcpu);
> >       }
> >
> >       if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
> > --
> > 2.32.0
> >
