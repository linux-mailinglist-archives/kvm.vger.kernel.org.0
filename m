Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC3D705D3E
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 04:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbjEQC1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 22:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbjEQC1o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 22:27:44 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863355FE1;
        Tue, 16 May 2023 19:27:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rw5KQ9Ii6gbtDWbJw1HW3+96fiC65KOBcUoDOwNFrlFVJ6NHiKD5ToYlf40v+D91+jMbRiKOfxoIXV6Tyx8yInAoHSoZ9kWAa36PFeuzdki8bGSiNlc2AJxHFA3L84CRgg04dXQv9mc8MNzjRWTAiASQPKe1TpraXh5ob5lbDa4YMNdNgVamGSvMG7U8Jcx5WJ/Mrr4yUcj+IRuQlCwFRET7ZDlMZ99CBkT7TBHRMGNOdhtaAovuh9nyhVnKdWAytSMMe872BUAnKNXtBwBrR0STIZy4RCDSlvcL9IR7F9enJY286U4YvDKpcAtwmxvLQeu7FCrCSwD0hnLbJyk+ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oh+jtBDcQGwKL47a/sTYNeBB8dtEGr5uAwWvDP8A28U=;
 b=cjI9rfNHyuGjqn5eWNtWxGeEkHpHAncNyDxbqWlCddNjLyefWOpkmpAv3dzFmr+vUvDYeRpIUmxcQjLJ1eDbOt10uslxaKouCbkk5PGt8ypNiT96MuF/weZWKcf5pasctuaol4QYVOQEyIvHQioXk5vpBXmVWYj5no9Ze9+P6eFZE0h/aCQfiSpoZuz2Sg8QXd+NWu+oBGIeVjVsLbh6UeCso+7cDesKNZ6YsqGKf34IaON+1Io964lBgQAdq/7FN0X2xXddTz+pI/5iJS1oBBoIWB9pWnFryIprWM4PhKhx5RFQsPFuYseQ6y3BasSlqNjpdtpArOcEgEQS3FqCEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oh+jtBDcQGwKL47a/sTYNeBB8dtEGr5uAwWvDP8A28U=;
 b=V5UI8iMWxWA5SNTBmjgCxrZwe0RW/XcBshERDXL7ftbQEgAJ5VHIatLCzn1dJVAeZIFC0ILf9iDAbt5wXO7bxtElmdb4rqjwKrOJcyGNiv41p9uLFq1bYHQDY5pZ1WQCHQtdW20hUUKm9uU3XmqW9S/ZKumv+IVd0+Gr1m41a7I=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by PH8PR21MB3815.namprd21.prod.outlook.com (2603:10b6:510:215::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.4; Wed, 17 May
 2023 02:26:37 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::a4f7:2466:97b5:bd31]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::a4f7:2466:97b5:bd31%5]) with mapi id 15.20.6433.005; Wed, 17 May 2023
 02:26:35 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>
CC:     Mark Rutland <Mark.Rutland@arm.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
        "kernel@xen0n.name" <kernel@xen0n.name>,
        "hca@linux.ibm.com" <hca@linux.ibm.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "svens@linux.ibm.com" <svens@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "longman@redhat.com" <longman@redhat.com>,
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "john.ogness@linutronix.de" <john.ogness@linutronix.de>,
        "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>,
        "bsegall@google.com" <bsegall@google.com>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "bristot@redhat.com" <bristot@redhat.com>,
        "vschneid@redhat.com" <vschneid@redhat.com>,
        "jstultz@google.com" <jstultz@google.com>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: RE: [RFC][PATCH 7/9] x86/tsc: Provide sched_clock_noinstr()
Thread-Topic: [RFC][PATCH 7/9] x86/tsc: Provide sched_clock_noinstr()
Thread-Index: AQHZgfVJgXDGJCXHgkicklmkIOtQvK9Q6JGAgAzfthA=
Date:   Wed, 17 May 2023 02:26:35 +0000
Message-ID: <BYAPR21MB1688853D01CABA74B51DA841D77E9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20230508211951.901961964@infradead.org>
 <20230508213147.853677542@infradead.org>
 <20230508214419.GA2053935@hirez.programming.kicks-ass.net>
In-Reply-To: <20230508214419.GA2053935@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5329c7e3-bfca-439e-a9df-2326ba163ea2;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-05-17T02:20:07Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|PH8PR21MB3815:EE_
x-ms-office365-filtering-correlation-id: c63e16e8-eeb6-4a29-5a22-08db567e22e0
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: waLSHBo/lES7jG6wG1LW2+XHWMJJ/G6gPu3InDad+lxE6TkKdxwR3D7dsrY8WCylV9F0iqMvmaVdgHDityFP3P7+ztGrLMft8oRqJrLHdjv4RYxXUli8Z2GacmEgbDrKp+1cid6tdluuqXX/EB1xL0X0XkKn51pGsmDfUVBUftXvZ8L0PiqvYDB7kAYIbnpPx4V0AjlccRG+k1m1FmH5YSv3uvX+28cJiVfM80vy7sMLzzCAEtLmDSNAWioP7/S9sdmDXc4IIfOtJ0nEg/3dPVVD7Whrhnw//ZxMMK+86brRfIUzsCZb2ZVu2hoN5wgET+jHoWArBqgntl8HosCs+VFST+Zw4J59FkL4FX2Yx28j4NBa+xCJPNy+yQf9/t9SXh3TOW5TICHEpo7zwqAlyxN7PdJz+P6Dli4qe/2hC3NJsEM7SGzvJDPeHygoaVVwjNJwfCkpAJYUXGRGVrU/tNkNiOUByR6PF/MJVRrtl/7MhUWGb6AyUCiwuaGdlE//h/dWN9cDhTzYTa7iWjbwckC2CAYVJzh/Ps+9k2Mte+Xf7kEHrBF7EoCI3dq+gbhI37pEzN6poQvUr2kQqsiPNQyAXp1jQIsTQK9gPdO9ZkRdjZ7wentXcQ+KxWbty2sekt1G1ApCY3K16vjvX0cn9WshYTSrhUOhE1yUMWNzkAk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(451199021)(83380400001)(6506007)(26005)(2906002)(33656002)(8990500004)(186003)(9686003)(38070700005)(52536014)(7416002)(86362001)(7696005)(5660300002)(55016003)(7406005)(71200400001)(8676002)(478600001)(64756008)(8936002)(10290500003)(54906003)(38100700002)(110136005)(41300700001)(66476007)(316002)(66446008)(122000001)(76116006)(4326008)(786003)(82960400001)(66946007)(82950400001)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WdBIUJO4K6JFXQfd53wgHzYQWp2Ie+ouaIGbeG4jIET39gzz+QIUB13AAGed?=
 =?us-ascii?Q?IeRD2NPpriFCuLUdTlPqJSXktq7FSZZQs3ErBZeZipBs2cUNQCdwh2G3Xpz7?=
 =?us-ascii?Q?FM0BNIoyWKTSJyHyE5Uk5nEjOLFVFkkTPleynUjUo6oq0VkYFEhZXhEourP+?=
 =?us-ascii?Q?1s5NhleSN2j+fN5CRhSjjQEDCI9P08vZIbgE/R5oB7pNOGO7OvXUKuq9oXL7?=
 =?us-ascii?Q?Xv9hPOOF5kPtblZAWhtW7TkhLWr2w6R4sJc8OOeJb2n20/KKk7D5bfpJ4MUz?=
 =?us-ascii?Q?shuGlxprq6aomK1mvNNj/FBpmET3qtE+bv87WDpZfw+/UAUKsAITSrqYrJYW?=
 =?us-ascii?Q?hI5CUpT1NDaPSfSkK9VXLCklhag8Y/9nrDGuHydFWiDI3NVGvJVTmMhXJTSz?=
 =?us-ascii?Q?5+iLBsos38ba3+l8gqlrkuijwfm50zUJr805w72i6iegmKee3jRz9yj8z3R6?=
 =?us-ascii?Q?NSgaRn313LIAGlG1C8ORR3gOGb3vzSHsa+Nqk5KR6splu67pIs0SYnWx3i/l?=
 =?us-ascii?Q?H9dA7Uzdy2oxzo5sHg3BHIYyDa4GWvKtEKqdTz+jZ+HcwTdvBwSnPTEUM+Ih?=
 =?us-ascii?Q?GBz26fFo1A7MCYEpf4VHuBtXiPTNB29Jy1NtuJfptbolkdAO7Ws75jDBebtc?=
 =?us-ascii?Q?+yzjMcZeHLKScZthMjqbsYSJY2lrV1M0xqtz1MAgVFB2AggdgpwntW9Vkpgg?=
 =?us-ascii?Q?JJCjpqlsKq4dtV6O4PIBgLr/SdKAc/+gat8qQ5xJkf3e9Atf2eAyZsKqqs7m?=
 =?us-ascii?Q?CMFbrMwIt5T/VMOScU2Q+/vseMA4rPNg+MRGdOFUCQ1EONIRFhIvbhawjR1a?=
 =?us-ascii?Q?zjy6XPvKaM07B/fgkhnq6JQS8heMwT6uxor6vFUaDJmDJvI+PbFkz96cz7fq?=
 =?us-ascii?Q?f0WHlxrZknHZcmWm+UA/yM4uTbt1hr2mUetpOY06ordtsIoT6XY3riWHG70r?=
 =?us-ascii?Q?b1TXf7/hMFhPcC1/Q6wMZvRXmZEwkvqLhlplcJDxkkgrG23Kmq2A3W9OUqRK?=
 =?us-ascii?Q?da1NPOI7JXwSdABJuKGdyD+EMF//+S9m3cTOBm/lZHwns3YAl9+36W7BMYoC?=
 =?us-ascii?Q?ml8MHPzSPe+UXBkijErSycGQMBmmKeYnAzs11DU5vqj5c8dnIljLdScHef1J?=
 =?us-ascii?Q?Jp257rJ2OdJOG6Uj/qcSw29+lzDTUtjMyAJkzMHe1yBEg/otRywl8zk+TAOB?=
 =?us-ascii?Q?O5qs8UR/7kQe6V/eLIBqHMkH/ec8puT/NoTo6/1XW1QewmuVCuYoaljE4PTP?=
 =?us-ascii?Q?oLxETYSF9CEXwN17/83XACkuuIKUPf25MFF4Zowcg6glcX9d1ZG4O/O+ekJK?=
 =?us-ascii?Q?COXyi25z1a0YLZx76vgqF+WrkEQFW1fQZDWyOcBVY8stgCJvU8Elw0ved7MQ?=
 =?us-ascii?Q?E81rci+C1CrG6oo4N6NzwJN53LV+7cD85JZoMTq8IGqvIVCCdVVOY5GaOh7l?=
 =?us-ascii?Q?4VXsWVIezPqw128XOqaPsKdrGZMJW5c+u+uUf1CtpQcfY0SC5sOBPG4S76dz?=
 =?us-ascii?Q?+kwHbf5JJ+1yDqUInRGRTQ48LP/T1sTLH1W79BHLZnsoWou99/MTq1kt5y2+?=
 =?us-ascii?Q?tHksHD5aCKdSkbyYS7XfxgyCaxjqFrU6UJZ8no7llmxGjOw0XqOrhZeTCz9a?=
 =?us-ascii?Q?GQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c63e16e8-eeb6-4a29-5a22-08db567e22e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2023 02:26:35.3749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FPZ4GOpGAuIx5bJtFl3Vkxr0ZAvJKjBDnZZrBToKIBr8lPXi7HEHtm0565mKm9ITiPtESmoeBR8nkfYMI0m0GhP0cax1h0qvGzwYwhXj3I8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR21MB3815
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org> Sent: Monday, May 8, 2023 2:44 =
PM
>=20
> On Mon, May 08, 2023 at 11:19:58PM +0200, Peter Zijlstra wrote:
>=20
> > --- a/drivers/clocksource/hyperv_timer.c
> > +++ b/drivers/clocksource/hyperv_timer.c
> > @@ -408,9 +408,9 @@ static u64 notrace read_hv_clock_tsc_cs(
> >  	return read_hv_clock_tsc();
> >  }
> >
> > -static u64 notrace read_hv_sched_clock_tsc(void)
> > +static u64 noinstr read_hv_sched_clock_tsc(void)
> >  {
> > -	return (read_hv_clock_tsc() - hv_sched_clock_offset) *
> > +	return (hv_read_tsc_page(hv_get_tsc_page()) - hv_sched_clock_offset) =
*
> >  		(NSEC_PER_SEC / HV_CLOCK_HZ);
> >  }
> >
> > --- a/include/clocksource/hyperv_timer.h
> > +++ b/include/clocksource/hyperv_timer.h
> > @@ -38,7 +38,7 @@ extern void hv_remap_tsc_clocksource(voi
> >  extern unsigned long hv_get_tsc_pfn(void);
> >  extern struct ms_hyperv_tsc_page *hv_get_tsc_page(void);
> >
> > -static inline notrace u64
> > +static __always_inline notrace u64
> >  hv_read_tsc_page_tsc(const struct ms_hyperv_tsc_page *tsc_pg, u64 *cur=
_tsc)
> >  {
> >  	u64 scale, offset;
> > @@ -85,7 +85,7 @@ hv_read_tsc_page_tsc(const struct ms_hyp
> >  	return mul_u64_u64_shr(*cur_tsc, scale, 64) + offset;
> >  }
> >
> > -static inline notrace u64
> > +static __always_inline notrace u64
> >  hv_read_tsc_page(const struct ms_hyperv_tsc_page *tsc_pg)
> >  {
> >  	u64 cur_tsc;
>=20
> Hyper-V folks!
>=20
> While reviewing all this I found the following 'gem':
>=20
> hv_init_clocksource()
>   hv_setup_sched_clock()
>     paravirt_set_sched_clock(read_hv_sched_clock_msr)
>=20
> read_hv_sched_clock_msr() [notrace]
>   read_hv_clock_msr()     [notrace]
>     hv_get_register()      *traced*
>       hv_get_non_nested_register() ...
>         hv_ghcb_msr_read()
> 	  WARN_ON(in_nmi())
> 	  ...
> 	  local_irq_save()
>=20
>=20
> Note that:
>=20
>  a) sched_clock() is used in NMI context a *LOT*
>  b) sched_clock() is notrace (or even noinstr with these patches)
>     and local_irq_save() implies tracing
>=20
>=20
> Can you pretty please:
>=20
>  1) delete all this; or,
>  2) fix it in a hurry?
>=20

Peter -- I've sent you an RFC patch to incorporate into your broader
patch set.  I think it probably makes sense for all the Hyper-V
stuff to be a separate patch.

I haven't previously worked with the details of notrace vs. noinstr,
but I followed the patterns elsewhere in patch set. Please review
to see if it seems correct.

One thing:  In the cases where I added __always_inline, I dropped
any notrace or noinstr annotations.  I presume such code always
takes on the attributes of the caller.  If that's not correct, let me know.

Michael
