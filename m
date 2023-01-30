Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC30681BEF
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 21:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjA3U5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 15:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjA3U5m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 15:57:42 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2075.outbound.protection.outlook.com [40.107.100.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2B246D63;
        Mon, 30 Jan 2023 12:57:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TfXHZKsR/tquplv+W/J22gKPpPFavFTFQbWnXcMv6iJymqznIVKAIIBIO70fIcn5DV8PZ7Qmkmja/ezehQRyL+y3yEImeuM+UD338MqH5QLJqrmjx1XHXA+w6imV/PeU5sZdhCfL2eiuqBmf4cO7I4wIAAtwnhevn8z7RkcKzjTsnDLvSct4A0KRMgTQz1aoU3Q87cyoYNecKWCNRDNiEzhN6g2w/FSIkIF5OdLsCNNQuI0xx1PPXp9HRUW+VXADe8xf/CpeC/dUwyg/+juDKDOBH2CtxqIpK/j9lK6yglEMfut/LsudZunw5KNH1RFslayqyUZ1n1RiRagCWk6wlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MEdz40oPQyPtZrkQPoCQtt9mWnzGTJNqCVBKp7yBuhI=;
 b=JX5kPbslyMePtrq1isViHUxr4MKI2oTf1Q4ZTiOPNpja1HlWzBMbHt3m9DqAIL+QHLZpfXb3imt4TBNJlCWfbuChmbl9E1cMETSQVMZ2YSCC5sAdvSjyljn6COxOxwV4vvShJbz0czlwKNtWXQprvTfkIvk2K6sn7jZ8R9uRF7i8oiP09znP7L87IgFO2g3RFjSz6TR1MV7B9m/9iWA75q0F1Lz6eE4OktoI89GpwQBoJg0Nhw4BOH2gMXy4yZuFqZqx2oEc0Dml6EvoUzPjVOxD2YVMDMWmMoTklwT1Z8r7M7KaHcktuBaDGBT1UdqDPOUh9CNGync5yH72dtizAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MEdz40oPQyPtZrkQPoCQtt9mWnzGTJNqCVBKp7yBuhI=;
 b=TBAJOPAAytKrjXsvvrfo/iYIXI3blzb3iRh7+R7FhfORKVN86nTmwhRZefnlmuRZ6HhOfo0anHcS5Dvifd+6gX15JrB9Ah9KGQVAPpqKxHqKynApKUxJvDi8oHiDDB8JxeuXX3dBFmpi+URVNoPff8qfbA8VnW7nkSmXwMEtsazv/cEUoIIxX/PGux1cJCqDl9YBTxjOIpCxnpPeBBaZwSr6mQucvOdW15+fTHTSqfZ3sg27OKWq0Pyb63TKNE6FEyTdnepSWJcXbtTmc16H+CZVIOX2trEkcbNtPU75zWdZZMJlwmNDWR89R0IRCD53hKR8oTNBEXwem+4WWBp51w==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by CY5PR12MB6297.namprd12.prod.outlook.com (2603:10b6:930:22::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Mon, 30 Jan
 2023 20:57:16 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::90c6:a307:66aa:70fc]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::90c6:a307:66aa:70fc%6]) with mapi id 15.20.6002.033; Mon, 30 Jan 2023
 20:57:16 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Chao Gao <chao.gao@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "shaoqin.huang@intel.com" <shaoqin.huang@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v6 5/6] KVM: x86: add vCPU scoped toggling for
 disabled exits
Thread-Topic: [RFC PATCH v6 5/6] KVM: x86: add vCPU scoped toggling for
 disabled exits
Thread-Index: AQHZLT1BGzppDhpj/kCgFA4ZExVfQa62kXiAgADtsGA=
Date:   Mon, 30 Jan 2023 20:57:16 +0000
Message-ID: <DM6PR12MB3500C858997C08CDDC956933CAD39@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <20230121020738.2973-1-kechenl@nvidia.com>
 <20230121020738.2973-6-kechenl@nvidia.com> <Y9dmwQNS1qufVwYZ@gao-cwp>
In-Reply-To: <Y9dmwQNS1qufVwYZ@gao-cwp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3500:EE_|CY5PR12MB6297:EE_
x-ms-office365-filtering-correlation-id: 2c129e67-9662-4a71-ad8f-08db03049213
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8H3cQ4OVkkJ2mQi9GbGtymmUK4caNkBzjHdN19+K12WeeRV4l1LKCD9T3Ly6dyk+DTQ7h8NM08m8+cSaceWi5nLFe40M91M2CV03XuIkLYA086ZIewC5KbUbBVjcH74RDw+rSRjzhA2iBuA3ezWzdx7IZk8iCjFBp8Ww4BI3xdVjYJGZ3rIAfFSKqnvqX0VaVDBRViDYghZcGs4X4M1T8lRhwZRwRXzfuPsq0Is99xmHO0ZMz7Wx0sJpNTKwWt8Uy8tzFBj6t+p7ThYDoQyPhay38Slm1Tm3dXfsXCbg4cHle7FebsZSuVg2B2yRQIjZZ0h7AHcuXPcO9JC7DJNV2zp1FwMn8V8/R9iXZYcx8rsJOCtIubZ8z23BhMKSl/5Xu5g/YkjPQ4s82dS0wg/vxW6HxcfsLRNXZQTjxQ1R4eIca+wnaPpLOB076uG/cdx+LI9M4kltdnoRajMoe5jJ038iWz2SnSDi6SXbbQ1PjIc9MHJjVEnksfARkM3bfRJ1dt2N6GeajJQ8NEr4XDEBkizhjk7um2pgSCO+PzXzq1o3SiG4heJGb2KjEI7WMCW8VzR/VRh9XcXYweUTl9LjWcdlsAOaidpxiphi2Pyf0YY1Et+mWqklgUR4z8xMDSHA+I2JV54kE5EVIEoDRrG718UGt0l70qBG9unbkoRN5mtzbwVEVpvTM9t1AIGqUn+RYIqv4VlaaxBSaeGt2rS7ueRizySYyaG7uHTY2Z9iX/o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(2906002)(5660300002)(122000001)(38100700002)(9686003)(186003)(26005)(54906003)(66946007)(52536014)(6916009)(76116006)(86362001)(4326008)(83380400001)(8676002)(41300700001)(316002)(66476007)(33656002)(55016003)(8936002)(64756008)(66446008)(66556008)(38070700005)(71200400001)(7696005)(478600001)(53546011)(6506007)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LgcIPoIpXVdssiE2lABGfAficDD1our8+AHXrc+S2rs5P6l439bLPF7lhexx?=
 =?us-ascii?Q?bFxEMR/qmn5D1lLbByKvax85w875ZawublNDpH9PEqaNUiADPzEJmelML27a?=
 =?us-ascii?Q?3tZ5wAzFJFBNcQb3gIb9fu4qTkkmVoH9kfed12n9D9TrMM5/e1JxVBWtZyRj?=
 =?us-ascii?Q?OHPNGSamZEQMLOPKNKeD6oc8lH2tRbEZL1XF3GMfm71lzDVSQ7SvO99og3so?=
 =?us-ascii?Q?vo7qxmOixiJGbFFHd1sFcJqZf/2K+Ieia1ow+9EaObd+a1sBciETFX4OvRQP?=
 =?us-ascii?Q?E+VcuirwH/A2F6gN635/iD+fQGBXM+sLd2pHnckxeJK0lx9hTzZNmBLVuakw?=
 =?us-ascii?Q?ySY8oubDxrHPrMGHZ+J8aIrKEGsjEOuf3gRiJq0WWMNH7OicEIf3oTqDECMX?=
 =?us-ascii?Q?F87MPZMbolVha6qmRFxN42CqA34ilE4T62PMS/xPF8QcSVHb2dNHWeq8EBSB?=
 =?us-ascii?Q?MqlUU5NweOj9AK7CiV4ddJcF7+dmQTVBLgNyT01G792BBUg9xZ/inTj+gwYi?=
 =?us-ascii?Q?o2zblSpgmct0hMgDYN+ltZDwlEGW+/vAL9EADEEkXvbWAIk87YeJwiFkeQGN?=
 =?us-ascii?Q?GfwPq/IPO0zZJ0KAD4tUEL8b/BqvNxsIxw2hK2g9Z5dATWS2ndeRXtMwVW9M?=
 =?us-ascii?Q?vtJgqhz20IhWW7bFbm6r7bQVM1CkP/Y/O/CF7c2vngYjof5gygsLj6QLJW1R?=
 =?us-ascii?Q?XfHCk+mtCXFbCwcsu6urWiPgqjBbL/YNAHHCzfrdfhYW7MQy6COULENyXW0h?=
 =?us-ascii?Q?qa9uVHl85JZV4lReOTodJLuokU5XU1ZThmJTjvUmVtndXKHlpaiL2tS5S4Kp?=
 =?us-ascii?Q?RMRbtmkqmh4h6NVcOgxK4fErBE4GwMX15UnmGtBllPrZALnnTu8UdhfRbiOA?=
 =?us-ascii?Q?O2mlYWiUl5vY2+tVFxsgqJSWMbgWl4wOGwchtTlOD1L/RhkVjH4xN0JxwS4H?=
 =?us-ascii?Q?18d6A9c0HOHjLIuawxdzPwdh+0IUciWOtOeKB1KHVYZh17LGudn1psMlNDNo?=
 =?us-ascii?Q?qESfBMpN53SX7L4NEDb7VGbGjF17NzifVhQIoboGXe7Q36UQmjDFauI9x3/U?=
 =?us-ascii?Q?UVT7yXcMkrhYGf82r+meuqYt+1aNS2PhF59m7fUXuxlWhR6AmbdItb1VeFuT?=
 =?us-ascii?Q?zgWV3MguglSX2A+cqaC4+KOtLiF1xP0Cm7qPaopnVjqz9pr9ra0KZAI5e+uk?=
 =?us-ascii?Q?pmW49E+9/x4IYKWJcUnBbyopwycraW1Vmcon9HHBUThs25dqfo26vq0UMeVJ?=
 =?us-ascii?Q?AjyFOeYfrwSWVaqCUnQF7Us290+B3wlEtlv5cJpo1tNIh7iHAzJoNdou5+et?=
 =?us-ascii?Q?Zg/xo+aaev9D8IqjG24A2pvfwc3+UHVq8tlY1+PM4yPA2L1PJ3o/AMdNvlDc?=
 =?us-ascii?Q?EN7VuVxRWTd1OiFiFCEdBjH/OqSNTUPi7IzNkCEi9gUFgJv2wyLDHpVVr9EK?=
 =?us-ascii?Q?3+DqRfPML+vBOUKPbDIcpNQLEEbd72kKAlSdPahUSSSw+BfnZCWy5lHKfIvF?=
 =?us-ascii?Q?v+xQ+EOaJCxB+0dbV7t5joh70qrwf7AFs4uZ0Osi2Q9oD4mQb0HlOZuZSuEC?=
 =?us-ascii?Q?8Plvm8jssM94FL/V1AxeXTSgMS/Au5cWMyd7xbLx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c129e67-9662-4a71-ad8f-08db03049213
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 20:57:16.8104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AjXCREC0pNtCTy5J/aXoPFsHLbEsAqwNqnPTs83P29Bx5ZGl6kDp9cIZ5Z3tqncRRyzCKJTKXYbygb87spy+jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6297
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
> Sent: Sunday, January 29, 2023 10:42 PM
> To: Kechen Lu <kechenl@nvidia.com>
> Cc: kvm@vger.kernel.org; seanjc@google.com; pbonzini@redhat.com;
> zhi.wang.linux@gmail.com; shaoqin.huang@intel.com;
> vkuznets@redhat.com; linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH v6 5/6] KVM: x86: add vCPU scoped toggling for
> disabled exits
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Sat, Jan 21, 2023 at 02:07:37AM +0000, Kechen Lu wrote:
> >+static void svm_update_disabled_exits(struct kvm_vcpu *vcpu)
>=20
> Is it possible to call this function on vCPU creation, i.e., consolidate
> initialization and runtime toggling?
>=20

Chao, can you elaborate on this? If I understand correctly,=20
you mean replacing the current redundant code on vCPU creation=20
for checking the xxx_in_guest and set intercept, while instead, calling thi=
s=20
svm/vmx_update_disabled_exits()? Yeah, I think this makes sense to
me.=20

BR,
Kechen

> >+{
> >+      struct vcpu_svm *svm =3D to_svm(vcpu);
> >+      struct vmcb_control_area *control =3D &svm->vmcb->control;
> >+
> >+      if (kvm_hlt_in_guest(vcpu))
> >+              svm_clr_intercept(svm, INTERCEPT_HLT);
> >+      else
> >+              svm_set_intercept(svm, INTERCEPT_HLT);
> >+
> >+      if (kvm_mwait_in_guest(vcpu)) {
> >+              svm_clr_intercept(svm, INTERCEPT_MONITOR);
> >+              svm_clr_intercept(svm, INTERCEPT_MWAIT);
> >+      } else {
> >+              svm_set_intercept(svm, INTERCEPT_MONITOR);
> >+              svm_set_intercept(svm, INTERCEPT_MWAIT);
> >+      }
> >+
> >+      if (kvm_pause_in_guest(vcpu)) {
> >+              svm_clr_intercept(svm, INTERCEPT_PAUSE);
> >+      } else {
> >+              control->pause_filter_count =3D pause_filter_count;
> >+              if (pause_filter_thresh)
> >+                      control->pause_filter_thresh =3D pause_filter_thr=
esh;
> >+      }
> >+}
> >+
> > static void svm_vm_destroy(struct kvm *kvm)  {
> >       avic_vm_destroy(kvm);
> >@@ -4825,7 +4852,10 @@ static struct kvm_x86_ops svm_x86_ops
> __initdata =3D {
> >       .complete_emulated_msr =3D svm_complete_emulated_msr,
> >
> >       .vcpu_deliver_sipi_vector =3D svm_vcpu_deliver_sipi_vector,
> >+
> >       .vcpu_get_apicv_inhibit_reasons =3D
> > avic_vcpu_get_apicv_inhibit_reasons,
> >+
> >+      .update_disabled_exits =3D svm_update_disabled_exits,
> > };
> >
> > /*
> >diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c index
> >019a20029878..f5137afdd424 100644
> >--- a/arch/x86/kvm/vmx/vmx.c
> >+++ b/arch/x86/kvm/vmx/vmx.c
> >@@ -8070,6 +8070,41 @@ static void vmx_vm_destroy(struct kvm *kvm)
> >       free_pages((unsigned long)kvm_vmx->pid_table,
> >vmx_get_pid_table_order(kvm));  }
> >
> >+static void vmx_update_disabled_exits(struct kvm_vcpu *vcpu)
>=20
> ditto.
