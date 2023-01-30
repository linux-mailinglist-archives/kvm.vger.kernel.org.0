Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD96681B59
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 21:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjA3UZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 15:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjA3UZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 15:25:21 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB6238B51;
        Mon, 30 Jan 2023 12:25:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHr6Z2PgRlFlVjVeu9gWEbOZKvl9NmtczNcuDGi4/jpYrq7xSAi3tkqt1S27JG3+u8zD4p6LqtpGGbKGNB4ukRroR5m5rGHkW+a2SVVRTwsewQQwTuM3rsF4awbT3AneeYII/MYExp6GbPMruVSzQLzObKXBNATcG0GKpdIu+Op8BpmEzA45/ocYFGSM3R+No94bJBHZjj+dw/XKRMdbi/UsQTHtMMtmeruMz3vaiT6IQFN6Y2y+r6JXoAT5g/XSUhtjQaSVfleiz658wWuuTPf2xaHLEDg6zVSjILaDUntYbRR507frDL1LtG3mWBLYQGSSO3ZsH1QnlJDKiouTVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dD++tfp6eHwgR9sSGeLOtSkN7zOyu/4f1ou321ckv8s=;
 b=lkZ9vn+p1qJhs6FX/YJrU78IYzfLJdPSn7HnUd6KIY8YYNHw5jsalkmQ9RvrDYobqiGFnYXPb/rwcTqcigsLaeKVomhxAH3ITve0KqRfGq0hY2lZ0AEdHvjsLjJM3sFnjhmECUE8aA/KhHVb2eaWIkRlj5Y3hwVYOWfG1r0+EY5/afzqv6c+ltIFuvgunPjI9XAnmq1Zt4WX2puQHjv4qoWuaFc8d0gu9X1oOBNphdCm52xMPQgkNSb1ldSVwWuNs3U+g9xVU+WoIH3MsbaXByJBkiKxf+8UaADqXMKS1v3ysyqv+DrSSxXnTzD9emdrbadLeJ2oA+qUfvVUFKEGag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dD++tfp6eHwgR9sSGeLOtSkN7zOyu/4f1ou321ckv8s=;
 b=oPvy2gkNhIKsOvwT/TQsZRxph7NIb+PzIb11wx1n7uyC6YHhC4OBjUVEI43/sjapzpzhMqVlUCsHsDradAPXOAuXDJwbHukN8O7ogG4cU1EGw+AkLo9tRDGogumJ+TB1BWryxcxJJmvsM6X4raegNwEpfHHU6pGZwutEGd7BOIXj+5wdXuVBC1rxgGOrSAgdzU5W61T0NZQln/hehrN5OozzpuTP1fN1nTY07aZySy11woie9FSnQap7YtLh2b57VzruSUYius221WF5Gb0zOmx+Dpp63AawVTw2PtAJ4VfqDEXQ/6E0vb2mrMnA6rXqAYAwRAHhhtlcSpZ7nVimeQ==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by BY5PR12MB5511.namprd12.prod.outlook.com (2603:10b6:a03:1d8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 20:25:11 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::90c6:a307:66aa:70fc]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::90c6:a307:66aa:70fc%6]) with mapi id 15.20.6002.033; Mon, 30 Jan 2023
 20:25:11 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Chao Gao <chao.gao@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "shaoqin.huang@intel.com" <shaoqin.huang@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v6 4/6] KVM: x86: Let userspace re-enable previously
 disabled exits
Thread-Topic: [RFC PATCH v6 4/6] KVM: x86: Let userspace re-enable previously
 disabled exits
Thread-Index: AQHZLT1Ah+DJ4yeqk0ejnCwHWxCqn662iwSAgADlkZA=
Date:   Mon, 30 Jan 2023 20:25:11 +0000
Message-ID: <DM6PR12MB35009DA05F3BB84112276B28CAD39@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <20230121020738.2973-1-kechenl@nvidia.com>
 <20230121020738.2973-5-kechenl@nvidia.com> <Y9dhV3dBpRYQ2jJv@gao-cwp>
In-Reply-To: <Y9dhV3dBpRYQ2jJv@gao-cwp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3500:EE_|BY5PR12MB5511:EE_
x-ms-office365-filtering-correlation-id: 5db4d474-4dc7-4a77-6279-08db0300164a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zL3pPoqPEfkCVE7O1iQ8dxLsTSlncyGUFNFd+dPQiUyDg9MmusjeM8JHucfz00xUeVs18Tg66WQckKl4+9TS15wMbht/cjq3+HWoOSFBMgCsC5lAOSU+uB1GICJ8d1JHJ3KNRxkX4OMQRnUBJeFl2WBnhozpKvl6TxwcNUpCXD0vzfBF3r3gOBN+OmtkiBviGNZhnId0QGlIrKhd7qVViMbI4sfDH7LwxV7FY4Iuh3ImuOrkfFvKqQ/6lui+RxcpkhBiEN1myxa69wl9GvuNXyZ03RWn1udcAipGrHaYsmFARM+NYt2RijzqCT1kq781oMj2/aPWDZIW/xERWAD9RNMYsKGZlJ5H7LtMP6AvfXJs34z7eLR2L6UMj+qjAh4wyarJd1WmNlF+ymAJcENM/Br9gHgzOmdjt35PALjqLjds6HqN/0K1759mtfUVdeOcEEBsLIzLCl3feKMZ+9n9itbBMLueAErZibuzgscmdgb8ed4r+ctYAdBgGuPU/UjHEPRBPSV26CL1l9qjCAVRwkecPXlwPQS6a5tc8U0F9CD3vMmxfdX80q6+/limhgPthmTjBZDYIG44ix5vINTj4nro9hx1UEP2SH7VlEoglA7VzAhovm8In2ibVB81wHf0D5alzg19m5s8PczeltD/NfIAoy0hb2u2IOHiUCiJMM567JCx6+1+nCoR9j2ieHARxESQPM2B3jepo0HpDW8ANw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(346002)(396003)(376002)(366004)(451199018)(2906002)(52536014)(5660300002)(38070700005)(86362001)(83380400001)(8936002)(41300700001)(478600001)(71200400001)(26005)(7696005)(9686003)(186003)(6506007)(53546011)(33656002)(54906003)(4326008)(66476007)(38100700002)(66446008)(66946007)(76116006)(8676002)(66556008)(6916009)(64756008)(122000001)(316002)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+i5tRh+sX4iDqUqdB5X3oTGCPuOZpJFNlJy7DCyW+Jf8bNwbYcQp6fWfsCTJ?=
 =?us-ascii?Q?dMb620B9OwhFe0snLT8q1I8q5YFWqHjGLhYe7JRN12L9sOehOeD2wv+TBPMS?=
 =?us-ascii?Q?UkwhQOs+QP6BOF5nIGiT51o+7ayZd3sNH3w8cx0zvY0jyfM19wAzw4eMOGUB?=
 =?us-ascii?Q?NhVVbBbTcM2M7JZBmQqBBNWgu6U0hGquQ3p3d5rSiWcFSkBMk5sLVDMRKFD0?=
 =?us-ascii?Q?9rc8AdRlghZ8aVCZrDpuqu4kq6YimSPXZvbnc+TwtizjAehsYRWiyeuv70QY?=
 =?us-ascii?Q?2FbmiZto1mvmfBTT93qv+qll8mAFJRwlnDZ0CLpil2px5rzpLTitlQTafqzR?=
 =?us-ascii?Q?eT6hTxesCE0T4hCecPLBRd2EupOfH57dNGqMQ6apFY2GoLyf7/wmR0Eezjst?=
 =?us-ascii?Q?7AO/DrPQ+SkZmr5X2KMtAR+xheBQUI3cDWTc8yPbawK18C8TjxGuUrfp+16/?=
 =?us-ascii?Q?CX7hzagBloJLKgRsk9Jeq1KFPgrLz0FBQSj18c4Y1DAZlqlW6LPwx6GX/hsX?=
 =?us-ascii?Q?2LktQ4GxX0EEiDYin/Z/oNvmAVpgliNahrBApg/1yj8mD9c5seQIQyhejeTT?=
 =?us-ascii?Q?KBpWcZ2PC5XLq4GKQAeAJrujoHCNZAzOnsOhGKNBD+4D4kBKfGjoy40eIF/Z?=
 =?us-ascii?Q?3KWv+Og+mnGh/VXv4+fJx46hy+JTTtayCt401jvxMHNyxs9i5w0Nb3XauDPw?=
 =?us-ascii?Q?7eg8cOTMGkQ1h6ShZDvMC8XuOzn7loG8x0RmwJwbrEXlxt2rFMMfXtAKJbxP?=
 =?us-ascii?Q?5Ij615SFzgiE3IUrx1rtk26NnzWa/8FJUO5eVMRt7yS62Byw0w314Y6I7n6q?=
 =?us-ascii?Q?P5OSRWqwgcg9pwRwvyX1KDHWJu3msTzCBRnLxf1mHtq4opwWKuZGflkpaMsl?=
 =?us-ascii?Q?DDIlJk/jTnO+g39Oe7bVYv8K71/ifV721zV19Uf9F6R4/8cIPrDkWz9ph0pi?=
 =?us-ascii?Q?lgeNsUtW4t9xcq4Qmp9Lg3Ev4Y3vGsAp5xrY1p5gXanw3FVNbnEOqXgKUJAy?=
 =?us-ascii?Q?14mksyCiQ/Mu/PzuuEbvPDcvaf0b7tTnvq/32FrO33iB7Sg0jO+eb+glwcie?=
 =?us-ascii?Q?HE+KJCC3CigQbh3RPT28GtCnlS4ym3OEe+vHbfeEC5TvV0rJyUJjy5cd0tYf?=
 =?us-ascii?Q?e0u9YLZ6t1fnimxDJ1E8c5Lmc+Gq/s3drp+aMh3ICJJhDCfbJuc20PYOjSfp?=
 =?us-ascii?Q?SDNv9SWxt0uSGi1bKaljuCovC2tuCmIylaNfiHkNjzcrHaFx5lfJRgv4c72q?=
 =?us-ascii?Q?K7eWYii1tLVJkhqg5NjJTBmdTqE7cZ9VbMtGomWZYOP8PXyV8XhjEo1BbCIn?=
 =?us-ascii?Q?1KsAgBK8QlvDXcYYIVF7V2eZe8t11U5cLWz+SDmLc7Z6tlbCK2JKBCdS+jtL?=
 =?us-ascii?Q?Boc0Ftm5bG2Nl/iD4qgkn5FlL6D11+BPktS2r9DbK/iWzh1oc1ANSQkS7WMT?=
 =?us-ascii?Q?PdAg/hUWvzqIHXHqNiwcJtcCngeDZ4a2IvdBqpqvjv1EJJQLiouc/lOki5k9?=
 =?us-ascii?Q?rFy+W6PlxxVJAtW7JXi0D+0UXHdiqCqz9lo9tqh/iENL04IRfldtA/8z9I93?=
 =?us-ascii?Q?5am3yeDEjKkHYLAOY0GeMiBPxedxPBLxI7mLHp0l?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5db4d474-4dc7-4a77-6279-08db0300164a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 20:25:11.1445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QKILNaG5kBFGXtKNanCHq7+DrJFPN28v2BxbEEbT7VqNf/jcit2TIDK3YwWJFEXzjGa3Gi+DipnXmbjuTCk6wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5511
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Chao,

> -----Original Message-----
> From: Chao Gao <chao.gao@intel.com>
> Sent: Sunday, January 29, 2023 10:19 PM
> To: Kechen Lu <kechenl@nvidia.com>
> Cc: kvm@vger.kernel.org; seanjc@google.com; pbonzini@redhat.com;
> zhi.wang.linux@gmail.com; shaoqin.huang@intel.com;
> vkuznets@redhat.com; linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH v6 4/6] KVM: x86: Let userspace re-enable
> previously disabled exits
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Sat, Jan 21, 2023 at 02:07:36AM +0000, Kechen Lu wrote:
> >From: Sean Christopherson <seanjc@google.com>
> >
> >Add an OVERRIDE flag to KVM_CAP_X86_DISABLE_EXITS allow userspace to
> >re-enable exits and/or override previous settings.  There's no real use
> >case for the per-VM ioctl, but a future per-vCPU variant wants to let
> >userspace toggle interception while the vCPU is running; add the
> >OVERRIDE functionality now to provide consistent between the per-VM
> and
> >per-vCPU variants.
> >
> >Signed-off-by: Sean Christopherson <seanjc@google.com>
>=20
> Kechen, add your signed-off-by as you are the submitter.
>
=20
Ack! Forgot this.

> >---
> > Documentation/virt/kvm/api.rst |  5 +++++
> > arch/x86/kvm/x86.c             | 32 ++++++++++++++++++++++++--------
> > include/uapi/linux/kvm.h       |  4 +++-
> > 3 files changed, 32 insertions(+), 9 deletions(-)
> >
> >diff --git a/Documentation/virt/kvm/api.rst
> >b/Documentation/virt/kvm/api.rst index fb0fcc566d5a..3850202942d0
> >100644
> >--- a/Documentation/virt/kvm/api.rst
> >+++ b/Documentation/virt/kvm/api.rst
> >@@ -7095,6 +7095,7 @@ Valid bits in args[0] are::
> >   #define KVM_X86_DISABLE_EXITS_HLT              (1 << 1)
> >   #define KVM_X86_DISABLE_EXITS_PAUSE            (1 << 2)
> >   #define KVM_X86_DISABLE_EXITS_CSTATE           (1 << 3)
> >+  #define KVM_X86_DISABLE_EXITS_OVERRIDE         (1ull << 63)
> >
> > Enabling this capability on a VM provides userspace with a way to no
> >longer intercept some instructions for improved latency in some @@
> >-7103,6 +7104,10 @@ physical CPUs.  More bits can be added in the
> >future; userspace can  just pass the KVM_CHECK_EXTENSION result to
> >KVM_ENABLE_CAP to disable  all such vmexits.
> >
> >+By default, this capability only disables exits.  To re-enable an
> >+exit, or to override previous settings, userspace can set
> >+KVM_X86_DISABLE_EXITS_OVERRIDE, in which case KVM will
> enable/disable according to the mask (a '1' =3D=3D disable).
> >+
> > Do not enable KVM_FEATURE_PV_UNHALT if you disable HLT exits.
> >
> > 7.14 KVM_CAP_S390_HPAGE_1M
> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c index
> >60caa3fd40e5..3ea5f12536a0 100644
> >--- a/arch/x86/kvm/x86.c
> >+++ b/arch/x86/kvm/x86.c
> >@@ -5484,6 +5484,28 @@ static int kvm_vcpu_ioctl_device_attr(struct
> kvm_vcpu *vcpu,
> >       return r;
> > }
> >
> >+
> >+#define kvm_ioctl_disable_exits(a, mask)                               =
    \
> >+({                                                                     =
    \
>=20
> >+      if (!kvm_can_mwait_in_guest())                                   =
    \
> >+              (mask) &=3D KVM_X86_DISABLE_EXITS_MWAIT;                 =
      \
>=20
> This can be dropped or should be a WARN_ON_ONCE() because if kvm
> cannot support mwait in guest (i.e., !kvm_can_mwait_in_guest()), attempts
> to disable mwait exits are already treated as invalid requests in patch 3=
.

As last time Sean suggests adding this workaround in case some hypervisors=
=20
apply without checking supported flags. Would prefer WARN_ON_ONCE().=20
Thanks!

BR,
Kechen

>=20
> >+      if ((mask) & KVM_X86_DISABLE_EXITS_OVERRIDE) {                   =
    \
> >+              (a).mwait_in_guest =3D (mask) & KVM_X86_DISABLE_EXITS_MWA=
IT;
> \
> >+              (a).hlt_in_guest =3D (mask) & KVM_X86_DISABLE_EXITS_HLT; =
      \
> >+              (a).pause_in_guest =3D (mask) & KVM_X86_DISABLE_EXITS_PAU=
SE;
> \
> >+              (a).cstate_in_guest =3D (mask) & KVM_X86_DISABLE_EXITS_CS=
TATE;
> \
> >+      } else {                                                         =
    \
> >+              if ((mask) & KVM_X86_DISABLE_EXITS_MWAIT)                =
    \
> >+                      (a).mwait_in_guest =3D true;                     =
      \
> >+              if ((mask) & KVM_X86_DISABLE_EXITS_HLT)                  =
    \
> >+                      (a).hlt_in_guest =3D true;                       =
      \
> >+              if ((mask) & KVM_X86_DISABLE_EXITS_PAUSE)                =
    \
> >+                      (a).pause_in_guest =3D true;                     =
      \
> >+              if ((mask) & KVM_X86_DISABLE_EXITS_CSTATE)               =
    \
> >+                      (a).cstate_in_guest =3D true;                    =
      \
> >+      }                                                                =
    \
> >+})
> >+
> > static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
> >                                    struct kvm_enable_cap *cap)  { @@
> >-6238,14 +6260,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >               if (kvm->created_vcpus)
> >                       goto disable_exits_unlock;
> >
> >-              if (cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT)
> >-                      kvm->arch.mwait_in_guest =3D true;
> >-              if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
> >-                      kvm->arch.hlt_in_guest =3D true;
> >-              if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
> >-                      kvm->arch.pause_in_guest =3D true;
> >-              if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
> >-                      kvm->arch.cstate_in_guest =3D true;
> >+              kvm_ioctl_disable_exits(kvm->arch, cap->args[0]);
> >+
> >               r =3D 0;
> > disable_exits_unlock:
> >               mutex_unlock(&kvm->lock); diff --git
> >a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h index
> >55155e262646..876dcccbfff2 100644
> >--- a/include/uapi/linux/kvm.h
> >+++ b/include/uapi/linux/kvm.h
> >@@ -823,10 +823,12 @@ struct kvm_ioeventfd {
> > #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
> > #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
> > #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
> >+#define KVM_X86_DISABLE_EXITS_OVERRIDE             (1ull << 63)
> > #define KVM_X86_DISABLE_VALID_EXITS
> (KVM_X86_DISABLE_EXITS_MWAIT | \
> >                                               KVM_X86_DISABLE_EXITS_HLT=
 | \
> >                                               KVM_X86_DISABLE_EXITS_PAU=
SE | \
> >-                                              KVM_X86_DISABLE_EXITS_CST=
ATE)
> >+                                            KVM_X86_DISABLE_EXITS_CSTAT=
E | \
> >+
> >+ KVM_X86_DISABLE_EXITS_OVERRIDE)
> >
> > /* for KVM_ENABLE_CAP */
> > struct kvm_enable_cap {
> >--
> >2.34.1
> >
