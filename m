Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8A4470DF56
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 16:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237124AbjEWOea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 10:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbjEWOe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 10:34:28 -0400
Received: from BN3PR00CU001.outbound.protection.outlook.com (mail-eastus2azon11020017.outbound.protection.outlook.com [52.101.56.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D60E0;
        Tue, 23 May 2023 07:34:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bsaz2P9s6ZlRLGTMDloEQKZ5DyaHkOoZuFDL+tmtio4EhuqCfRpnJLvRzXOtVWhpOzYlNILKziahsQuiwK41PjTWBMetfEc7kLO8Fi0SDhJqQObSf3Siocbi/3+luYT8ya8/FawvRXHGZ8D3pGR/pY8J9OR/hsn04VTB7MDV7CbiKQFtw27q7DyuFe1hf93nIxxszCsGWk/LWNUXXrIVl2lcyywkqj9weuUWv1djEdpxdorQ27JLgZ+tYxk+2KYFVjb+l4kWL01WnaeZCUDpnub+rsKL/vURfj/uPFGXtTmCRAPaxxhdfFIHRrjFVBs4arJKwJ1OO3GQV1V9FSkuGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S+cctbfDky0Y8n2oto81YsPUnyxlY1kgjkAI6Jyy6iw=;
 b=esV6wYZj5bPS9DurAmim64KJz1YnAEwwOp/b+zTD2jV2WSxvx971Phi0Ug5JnvvyjC5ZdeysN4Ng5/QIEO2vvwceYmgsNn+nPi3ZZ17WI0I/xiBJ+Egv0SeCbGLNio0wDTVc8NLFPbE8/s3avmzE4FvZgjQJ0n6xhfC1cLQ//E3cAahSuTKsHijT5Hh6/hk8/XkcuKcdbu1hghf6S4+MQ7bgqMAj9zZh4GRWSclWwI7zVTmTtjsNRKDHnQIB3G5/oSvDyb1hOipd/1ia3g8ZPYeoYpAQ9sKyjsVEG/QHf0dH5HNKwxh3J2kReGkWHp9zNrJFaShQqH9RUTjy1CtPpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+cctbfDky0Y8n2oto81YsPUnyxlY1kgjkAI6Jyy6iw=;
 b=SfHj7QHcj1rI3tQZC5/eMT/1JNLxJiAMQetXSc/5wD411yL7+18rbZY8RD6JDf+6duTFyW/slYeUnoqVhi6hhwDrNkzYzJJL4rH8QThZ0SjNxVhNKPtci74PKKKdkH8EcopXPaOUk4c6grhQ05zjea988MWk5R+BsPCInl729yg=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by PH0PR21MB1910.namprd21.prod.outlook.com (2603:10b6:510:1b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.13; Tue, 23 May
 2023 14:34:24 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::a4f7:2466:97b5:bd31]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::a4f7:2466:97b5:bd31%5]) with mapi id 15.20.6455.004; Tue, 23 May 2023
 14:34:23 +0000
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
Thread-Index: AQHZil8FRZ0qOnNN10G7K787DJGg/a9mAb2AgABWn6CAAS1hgIAAbJ2Q
Date:   Tue, 23 May 2023 14:34:23 +0000
Message-ID: <BYAPR21MB16884F0DFBCF2B419AF46EC1D740A@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1684506832-41392-1-git-send-email-mikelley@microsoft.com>
 <87o7mczqvu.fsf@redhat.com>
 <BYAPR21MB16889F38274F6F7691DB85F8D743A@BYAPR21MB1688.namprd21.prod.outlook.com>
 <87wn0zxylc.fsf@redhat.com>
In-Reply-To: <87wn0zxylc.fsf@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=28520d20-9fa7-468b-af0e-f88769c50adf;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-05-23T14:33:31Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|PH0PR21MB1910:EE_
x-ms-office365-filtering-correlation-id: eac6c40f-76c1-4b73-d791-08db5b9acdac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qisHd5gEk7ikcyC+NjqyrhDsDVtjhm5i/JLGKsFq1Sdbvahm9WquS4xD7R1DzdQ4itXAoEIpzalh3n/yMIoe7BtVEVYjpzPPIUIZDLjkZuay8noXOUjdqGGR+WuabW3OXSzmUBn67kL0dFikh+f9iPYVT6RnPWKv9CDStkYfk4Xm15d8F32HbZMB+WNyH4AQ4iILrbn6ZCzTKtV1qATSJIJnqADlWQABCTCKFgN0i58xJvcJOqsLgRzM8DC2AWKML97ZYo3nUr/qQc4fu8W8n4o6zir3U48CPWWquK2OJl2psiUBvHw7xGvGDiamlTLSPRhkOUOfbcZFsVeGcauua5tmj5jubv5TqnTYidmziaaOkMJjteY+o56msqGUiOYzrYZCFihudbIO4aGlEID68wPFJIXyMTbDongoI4wpEFQESOIPaFvhyjBC0hmQ5jOl6ZbOnumTskxYR4FxL9aRL4DRWLCEmDwnZ9zrzPjlKPAOfzJX+r3gRayo1H4RAewcrMpUcj3IUJBBlcO2QSTtVSIQuxLEu9x+ocL+ZhCGeo6Z9HW4r9DgfTGnxVFJNgIpd523zk/nKDiLstvnDqlOsAUvK34D9yhNyxdYvU/TGArzREZ044dcUUMbRrSyrPSu9mpCeOXkyJlR3astmERVX4a3n3cFilXo/ZpVwgRqpDE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199021)(316002)(10290500003)(478600001)(6506007)(26005)(9686003)(786003)(71200400001)(54906003)(66946007)(76116006)(66556008)(66476007)(66446008)(64756008)(4326008)(41300700001)(6916009)(7696005)(52536014)(8936002)(8676002)(5660300002)(7416002)(86362001)(55016003)(2906002)(83380400001)(33656002)(122000001)(82950400001)(38100700002)(38070700005)(8990500004)(186003)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tredA7MX6ofHOaopL+ozPcbNegjgRrN1WJ74pW2fB9ZGBLo3Mbdu1d3jiPTm?=
 =?us-ascii?Q?64LL3dCABpr20x5uK48BVlrevubU8YJ1Egu5uX+c/0i7J/jHGDnp53twklmC?=
 =?us-ascii?Q?E4XZFjUEvCcZx1mN8dDObIiTZZ9DOJ0WDT5Ro2zL97S+nrshqzubmRK3cVrh?=
 =?us-ascii?Q?/Udf+GL7f7zUNP16h7XUVkZFu/MInEZ3DN50GrQh49u9a7j+h50RXYbZrLho?=
 =?us-ascii?Q?1Qm6GA6BaYHxy1UPAG8FVGbZMc92fQYLsb1Z78P2C0f9PzWcDtt4BYtNuAlR?=
 =?us-ascii?Q?QRkFJP1t6dt4HgHDjE86nJGtNWMEp6H7ANOEdLiQn5yLobmpSNxIcHG4xF2P?=
 =?us-ascii?Q?KOqnZcUEHGajL7zwkVQbdiMbW24Zee39pl6XXyb3kyg4qXkvB58N6RBXivhn?=
 =?us-ascii?Q?IwrhXAwcYSQkW0O+wh30vl66UTZYvSj4XBdBz8NuMWvcZsqMlrNjl8nGVkfu?=
 =?us-ascii?Q?ZROO5Cgoo2B3Nxsfw6OicoLcEoCAuZboAxLML2WuWIGbAMNuHNF7O5sRumrw?=
 =?us-ascii?Q?tY/1xqYcSmGOE5D55yxAT3R4QgyTOOPzXypkf7OI4WZAfB3aHaVIDw8o3giM?=
 =?us-ascii?Q?16bsEgJ0Dpti6Jm8fs4XgOy8Kz7FOqzuwe8i5UHUZFZEF1wixPg6kmIZILUx?=
 =?us-ascii?Q?ezG/qcyF5EcmJHcQUrTM5OPtINjo38NW+PCOQ/zINCnW0W5rImGxccyV5UWr?=
 =?us-ascii?Q?dEMihqmQ2kuq8/SQcFkNI8haWVAJ3AYM87Qq2Hy42uUo7RLO8vOe/lgtGCUf?=
 =?us-ascii?Q?3yQdpBFQnTs3cyA3jyviBrNnNA7hFg1FBqFqEprTRHfd2LsUZS9c4dB/aYlR?=
 =?us-ascii?Q?jh4vuKt2LQztDch5J/pmIU+jNZZZaCoSuQiWphhkDlT3sTUyu9dJeKDP+Efk?=
 =?us-ascii?Q?mS1toKMyVwsjqH3VwpL40YIuS4qwQpECUmCtk/t3RUwz6yTsx5S09dUs5E7O?=
 =?us-ascii?Q?uz3UMbVoUSO1FQ7RR/JMsdkZEL+h5+v1LWDpYDWfVDWEWhWHXeWNxLpRnyiI?=
 =?us-ascii?Q?rkymiRQzEnlWI2CWTL5UyLYc1jMhMn/xLBO6aFynp2yrOy4yoYWcKxZzdC3C?=
 =?us-ascii?Q?mxqp6PVuc68DGM6bc3ault8wkhl5Zh01gpQXxq44bmwHr8TZmR6h0r2w+gEd?=
 =?us-ascii?Q?Z7Mtd5FABkMgzUt1u6nU7L3TNqqf0vzU213OByG7uG5LPb55X20n9yF+m0m/?=
 =?us-ascii?Q?aIea7T5Q3Lgz+520iHhIOwJzonoiMwocs5NoUFiYhuFQSGuKjZnaYOKgl239?=
 =?us-ascii?Q?ol4IPvjSicoT90kYQQzmsfYvkFfXcEVrhhGJZB8IzL0HnBX7E8FJY7EbDeCE?=
 =?us-ascii?Q?9EI9HptpDV8eAlVE/7lzp0RS9bjpdGz50Mg51hPZ3dKGAoJkbKbm6sOw6XPk?=
 =?us-ascii?Q?RvFR5byYTi3ETRXRsql+NNrMEYB8hdRkLb1vgMJrhlhgvirtqcm/jyEkt59p?=
 =?us-ascii?Q?jFV3axm/UdX7j7MzocYod4bf1J2xwBiwgB9E6TvJSG0pxOhdgpwm/6YZlbx+?=
 =?us-ascii?Q?u17j1tUVEUThy7opr4eMk82M+al2AXjMHG5BdpFSmpIdrjKQ37FnOAltCjrx?=
 =?us-ascii?Q?P7Ma/lJf0th8Sd3GuuAWwxbpff2E8LH2Tr/evT9lhRYC70jVKKWywNwNFHPs?=
 =?us-ascii?Q?gQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eac6c40f-76c1-4b73-d791-08db5b9acdac
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 14:34:23.6348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2g0ZM6MfS+O37ALeNoR7cPuXe2lXP7h7W8Yy0z2pKF1ycGaByBBTJW1A/Jsb1fOZn5KvEeII0BLyvv/VkJ5JK1BuGZZYHV8hkmBbmuZNrHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1910
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com> Sent: Tuesday, May 23, 2023 1:=
05 AM
>=20
> "Michael Kelley (LINUX)" <mikelley@microsoft.com> writes:
>=20
> > From: Vitaly Kuznetsov <vkuznets@redhat.com> Sent: Monday, May 22, 2023=
 1:56 AM
> >>
> >> Michael Kelley <mikelley@microsoft.com> writes:
> >>
> >
> > [snip]
> >
> >> > diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
> >> > index 0f1001d..696004a 100644
> >> > --- a/include/linux/cpuhotplug.h
> >> > +++ b/include/linux/cpuhotplug.h
> >> > @@ -201,6 +201,7 @@ enum cpuhp_state {
> >> >  	/* Online section invoked on the hotplugged CPU from the hotplug t=
hread */
> >> >  	CPUHP_AP_ONLINE_IDLE,
> >> >  	CPUHP_AP_KVM_ONLINE,
> >> > +	CPUHP_AP_HYPERV_ONLINE,
> >>
> >> (Cc: KVM)
> >>
> >> I would very much prefer we swap the order with KVM here: hv_cpu_init(=
)
> >> allocates and sets vCPU's VP assist page which is used by KVM on
> >> CPUHP_AP_KVM_ONLINE:
> >>
> >> kvm_online_cpu() -> __hardware_enable_nolock() ->
> >> kvm_arch_hardware_enable() -> vmx_hardware_enable():
> >>
> >>         /*
> >>          * This can happen if we hot-added a CPU but failed to allocat=
e
> >>          * VP assist page for it.
> >>          */
> >> 	if (kvm_is_using_evmcs() && !hv_get_vp_assist_page(cpu))
> >> 		return -EFAULT;
> >>
> >> With the change, this is likely broken.
> >>
> >> FWIF, KVM also needs current vCPU's VP index (also set by hv_cpu_init(=
))
> >> through __kvm_x86_vendor_init() -> set_hv_tscchange_cb() call chain bu=
t
> >> this happens upon KVM module load so CPU hotplug ordering should not
> >> matter as this always happens on a CPU which is already online.
> >>
> >> Generally, as 'KVM on Hyper-V' is a supported scenario, doing Hyper-V
> >> init before KVM's (and vice versa on teardown) makes sense.
> >>
> >> >  	CPUHP_AP_SCHED_WAIT_EMPTY,
> >> >  	CPUHP_AP_SMPBOOT_THREADS,
> >> >  	CPUHP_AP_X86_VDSO_VMA_ONLINE,
> >
> > I have no objection to putting CPUHP_AP_HYPERV_ONLINE first.  I did
> > not give any consideration to a possible dependency between the two. :-=
(
> > But note that in current code, hv_cpu_init() is running on the
> > CPUHP_AP_ONLINE_DYN state, which is also after KVM.  So this patch
> > doesn't change the order w.r.t. KVM and the VP assist page.   Are thing=
s
> > already broken for KVM, or is something else happening that makes it
> > work anyway?
>=20
> This looks like a currently present bug indeed so I had to refresh my
> memory.
>=20
> KVM's CPUHP_AP_KVM_STARTIN is registered with
> cpuhp_setup_state_nocalls() which means that kvm_starting_cpu() is not
> called for all currently present CPUs. Moreover, kvm_init() is called
> when KVM vendor module (e.g. kvm_intel) is loaded and as KVM is normally
> built as module, this happens much later than Hyper-V's
> hyperv_init(). vmx_hardware_enable() is actually called from
> hardware_enable_all() which happens when the first KVM VM is created.
>=20
> This all changes when a CPU is hotplugged. The order CPUHP_AP_* from
> cpuhp_state is respected and KVM's kvm_starting_cpu() is called _before_
> Hyper-V's hv_cpu_init() even before your patch. We don't see the bug
> just because Hyper-V doesn't(?) support CPU hotplug. Just sending a CPU
> offline with e.g. "echo 0 > /sys/devices/system/cpu/cpuX/online" is not
> the same as once allocated, VP assist page persists for all non-root
> Hyper-V partitions. I don't know if KVM is supported for Hyper-V root
> partitions but in case it is, we may have a problem.
>=20
> Let's put CPUHP_AP_HYPERV_ONLINE before KVM's CPUHP_AP_KVM_ONLINE
> explicitly so CPU hotplug scenario is handled correctly, even if current
> Hyper-V versions don't support it.
>=20

Will do.  I'll send a v2 with the change.

Michael
