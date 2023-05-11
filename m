Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205A36FFCFC
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 01:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239349AbjEKXLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 19:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239281AbjEKXLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 19:11:13 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020016.outbound.protection.outlook.com [52.101.61.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C082D4A;
        Thu, 11 May 2023 16:11:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ciaEH+Z6In83CMi7NqhyvsPKY4Fda39txIY/pNfGvMHHHs5de04dF9++SlogkRqLPJB2JzAO7nTz0p2w4SAuyHnUUc0A0Z1giApkG363NXy7oHRq+PG/ecnKShxztKM0fPUZjeZGofEvoVOhPUVsgSX/+ACeoM52PgLSOJIoDDlLhSZwN9sDtn4yYQOHQvvWd0jivnv+KPrrN3A9A/GK5bNhh1z8fCK9w2BgNk/0r2Hx2ZWTLMLFOTT5YdiNABTA3e5sYyXso8zpZYgEcDe15RU5Ns4O8rX1zTdLESHq0X2NF6oK1b/AiSkmHVM+DEFoz4Zk9Y+hCPibl4K73aw01w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ujeer/oCkeK44NWTVzWsTpfORd9QmprGPyQHuuuYBoI=;
 b=XUFxNcW91jal/RrnkViNRXppweB/CYZrNNhbUzaQfwpAFSvmsNEKOwXUC+V/2Z5NnDCOQP04ZVE3pi7VF3K2FCdMfzRjHo5ICMqQwroHOxh/1GcOKEdtxbuDrTAR16deB2za0jO11AQMueX7SFkpqtlLiFsrPUE2X23b1PTZzv9z7ybwWJu/0/omCfTUob0JYZwbzdh8MmacHA0+l7MiLnrf66Ues9jc455DQUVQ7BM2F0Pemjinh8UwdI2xl6YOmiBG3WhRfAaVARjAOz15El2EPCVg87vRiczdsmoYliB/Vy/6ZFNJuIow5oPJabUKXe3TFFIpni1BoI2CFMsXmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ujeer/oCkeK44NWTVzWsTpfORd9QmprGPyQHuuuYBoI=;
 b=eYs29H7RAOHNZT0L0BMbol/UZyu9DcDD234BWc5lS2vdbiCWm4sAPXpEAVwk4LDKKBcUTSkdUZBcp4Inaw8xwK/HuKkG82BdbPAl7nR3NXcF1CGglFzxPIiWJxPOBWoV/5fGQRLrQUQwK7a3YO2s5Zh/z3gF5WpOhYko3X/juMA=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by SN7PR21MB3858.namprd21.prod.outlook.com (2603:10b6:806:2ed::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.0; Thu, 11 May
 2023 23:11:08 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::a4f7:2466:97b5:bd31]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::a4f7:2466:97b5:bd31%4]) with mapi id 15.20.6411.007; Thu, 11 May 2023
 23:11:08 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Peter Zijlstra <peterz@infradead.org>, Wei Liu <wei.liu@kernel.org>
CC:     "ltykernel@gmail.com" <ltykernel@gmail.com>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
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
Thread-Index: AQHZgfVJgXDGJCXHgkicklmkIOtQvK9Q6JGAgAAdu4CABILIgIAALlKQ
Date:   Thu, 11 May 2023 23:11:07 +0000
Message-ID: <BYAPR21MB16883A65BBCFA19A30BADA4CD7749@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20230508211951.901961964@infradead.org>
 <20230508213147.853677542@infradead.org>
 <20230508214419.GA2053935@hirez.programming.kicks-ass.net>
 <ZFmGI1EN24xroPHa@liuwe-devbox-debian-v2>
 <20230511202351.GE2296992@hirez.programming.kicks-ass.net>
In-Reply-To: <20230511202351.GE2296992@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d7099938-895d-4a93-9f19-d91b36949928;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-05-11T23:09:38Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|SN7PR21MB3858:EE_
x-ms-office365-filtering-correlation-id: 8cb8579c-9eb8-4f8b-3720-08db527500b3
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HmHhR5QZMcwFmEfKGKKBpwN8l1UEW1o8PJWoMTl35/c2go3i0s22YqpMF8y7xwqbHbX2hKP3W38L0NGbJrnZedSh1TI8fKJuyi4riybodYAbk39vtD28zsjoMTMZ9QP2AONWPfi7CrfK+WSC0qdxY+HB9Lp2GKbJP5tpYhprXem5ZsN0Zl4S5doiWdGjBy+C8oUeNnMVxlaqA+nZ6IbT6I5TVIxw9dKQPgFV5f1tJTvjVB0R6OJMku2hxZEE4endg0bDLbsAtO/US3IRPF/Yl+/KukxHQ9WcqZXmpfCt0lxsQhkq1WtoIqmrwaZG75AlCeGneMTWQWp3Zat6YuvyjWLr3cdvr2qrmBG9TVLOLVi/2vztcEfVoK28vJDre+Qbe0SPLym3DdCj7EyGdKPpu28ts6q87Lf3rywaeiqwW3Ds9sGytYQE/kd04rg2idLinNMu8miasqLaGDiroAuN9iILdRD3ZFhtaDXhBBBkcYnaARCH67V6AznoDnBnFZJBLvZzlLVn8DoGPSFs7uLNGo7psu4N0FrZOXecwfeFS0pIhKZ2K4f749+5hNnBMUvD206AEULZOOJch1KsKgJ0FswnB+EmlvWBFNVSPan7Sd9hcicOZbZp0KhmwKBNZI+jQlt/ZF14nPgf9DUHKLlv2exwShY/8kdROhHX63d+ygs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(366004)(376002)(136003)(396003)(451199021)(82960400001)(41300700001)(82950400001)(5660300002)(2906002)(52536014)(54906003)(38100700002)(26005)(6506007)(10290500003)(86362001)(186003)(76116006)(8676002)(8936002)(33656002)(7406005)(38070700005)(7416002)(66446008)(66476007)(4326008)(64756008)(316002)(66556008)(478600001)(786003)(66946007)(8990500004)(71200400001)(122000001)(55016003)(9686003)(83380400001)(110136005)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Rypu5/qSPXK6Oo1AhD4U9pkjNUyuW/5qGBPC1CO0NW56LkWK771767eSPzAK?=
 =?us-ascii?Q?nQyHduxjM+dA85kH+rae14Qh/ApSriyVHtspKStwjwobtwlZCXpRuqvB6j6I?=
 =?us-ascii?Q?XQAarunaWBEq4mchaUzRwXyB13nyzUvhbglz+gd96Eo0jP2HxmCG0rz48lHg?=
 =?us-ascii?Q?COJCuWIMCM56CbRfMn53Yi9TOUn6ET1qHKA2mU8OkCWfDhHYcaDn6Sl+oaoj?=
 =?us-ascii?Q?P+MAWL7Z65Y7fGBgPTQ7KU1Y19pi3DcFlZfKGl02GAnycv5gcmcM45k2X7yS?=
 =?us-ascii?Q?RLeIJjUbrNad5ZoDpLImbP+cUGYTtCSy6lajQRFXerIJhMiYKv0hcSTGASCp?=
 =?us-ascii?Q?j3uHiFl29WboZGz4R1CZqG6tOqy9akrI37dQvzgNGTu3gdEzwOrDMwx9YSM4?=
 =?us-ascii?Q?iUcqwL2L/HTsrpapLAuseZpa2RkjuzOYjtUJxhK/aprjmC9frVy6JyZL48Qu?=
 =?us-ascii?Q?nvPPmEFIju3mHx7T0QgoWRIp+aA1/EXxk72ZYb+LBxly8m69x/NtTj01r538?=
 =?us-ascii?Q?YV9eV7s4LHIE3LgJ8Mt+FzJRwf6fXJoU1M+lCxnwWfXI9DRj6Zo7T0hn9380?=
 =?us-ascii?Q?k0iAg9EAKzVGPsWD8rSsEV9RPXZ4S23d4oXnNV6NVZ7jz+gGwIwZ6KHJPlBu?=
 =?us-ascii?Q?uSkErsw3YPrFOMRn1zGG0uFs6nSfw0A3ssAgl94VvMOcNopX9398HI3LZMp5?=
 =?us-ascii?Q?gkebnzFAOCb+g+5B/nj6Gyxng0u8RocecyR3fbndR+9uq2QQLgV+J/X7tnzv?=
 =?us-ascii?Q?z2WrYW5OBGCAEvNwPheIycQ0CTXPXMmCfAwDGXnhesLzM9tz/tlpwVA7V+Mr?=
 =?us-ascii?Q?/jNdyqTJMsDt6Cv+PAZQjYWXkAqe/qgavJ40yc9RANh3coGZ7LqD6q8qT9Bu?=
 =?us-ascii?Q?X4veJc+3DPzSpCwYCs6kVXBq/cg7CFAHFRcxaM5uCs4PIoupMeJtYAlI44Hc?=
 =?us-ascii?Q?D/79XcEAwBsdhvY6vUQ+j8A0L7f5qTyzKEl0Ra2UQ8ELMw8WU4AymYAgXW+V?=
 =?us-ascii?Q?xodsh7fYyp3V4t/8hRw2mdF3RD59l8UeZaz8O7oUvdM/qRhWuF6e+H2IF3FV?=
 =?us-ascii?Q?vRU2YfEMaHDrZbWPBzprsfoh6YT9wORye7THLEDMcXt/ClBVwm1NcY9jRWWH?=
 =?us-ascii?Q?9trb6K/icu95fwfWNUAVzerlxDlw6C0rQDEaaYmedDZdja4ojr4wK65saiL2?=
 =?us-ascii?Q?WxedtR+jrn40jmPJhQL0zhMMO9FKY2JLzWV++ukg3XfMUBjGAwlpv78Bx2id?=
 =?us-ascii?Q?fcfNl8lR3KV2TKACqFNbkFym14EOLTc87N6d8RUrjzqIJeJwj+o10DxhEqL1?=
 =?us-ascii?Q?dEY+vD6a+OZIDe08xmBrmi56viBnXoZj7KUsWM9ySC0qPoQn3wd4GGh1xwxQ?=
 =?us-ascii?Q?fYoB7n6590duM8ImtCC4OPuf4T+rovUAjWxe4uAs0tckuJ3QDN3ku7cHZ4Sg?=
 =?us-ascii?Q?tB9f3xOeQq4HpJB4hBxWKY4DLxZiCRFHxD12MkFp/O7w38028t1Oejso5z5E?=
 =?us-ascii?Q?lM+/7RSCFNUbAmy03OvnkwKvEZ+4REIolc0zY5u+nfpAcCQrGNfckHbQPp2j?=
 =?us-ascii?Q?OXb+/kzsmS1Cx+o3jLPzG/yBVJkhWzq77fA3sBV7wF3tkFLvVCg8kg0P/wek?=
 =?us-ascii?Q?7Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cb8579c-9eb8-4f8b-3720-08db527500b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 23:11:07.9398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +GoYwVlFKF1eTKEtvHfgB9ND2IU8cVR/a1YxfF5Dc7PTur7Zm3hrhK63QWeSpuIw+aR2/knGpFZPwbB+NFJwpIOYDlfRqRBSPJa31TDJEoY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR21MB3858
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org> Sent: Thursday, May 11, 2023 1:=
24 PM
>=20
> On Mon, May 08, 2023 at 11:30:43PM +0000, Wei Liu wrote:
> > On Mon, May 08, 2023 at 11:44:19PM +0200, Peter Zijlstra wrote:
> > > On Mon, May 08, 2023 at 11:19:58PM +0200, Peter Zijlstra wrote:
> > >
> > > > --- a/drivers/clocksource/hyperv_timer.c
> > > > +++ b/drivers/clocksource/hyperv_timer.c
> > > > @@ -408,9 +408,9 @@ static u64 notrace read_hv_clock_tsc_cs(
> > > >  	return read_hv_clock_tsc();
> > > >  }
> > > >
> > > > -static u64 notrace read_hv_sched_clock_tsc(void)
> > > > +static u64 noinstr read_hv_sched_clock_tsc(void)
> > > >  {
> > > > -	return (read_hv_clock_tsc() - hv_sched_clock_offset) *
> > > > +	return (hv_read_tsc_page(hv_get_tsc_page()) - hv_sched_clock_offs=
et) *
> > > >  		(NSEC_PER_SEC / HV_CLOCK_HZ);
> > > >  }
> > > >
> > > > --- a/include/clocksource/hyperv_timer.h
> > > > +++ b/include/clocksource/hyperv_timer.h
> > > > @@ -38,7 +38,7 @@ extern void hv_remap_tsc_clocksource(voi
> > > >  extern unsigned long hv_get_tsc_pfn(void);
> > > >  extern struct ms_hyperv_tsc_page *hv_get_tsc_page(void);
> > > >
> > > > -static inline notrace u64
> > > > +static __always_inline notrace u64
> > > >  hv_read_tsc_page_tsc(const struct ms_hyperv_tsc_page *tsc_pg, u64 =
*cur_tsc)
> > > >  {
> > > >  	u64 scale, offset;
> > > > @@ -85,7 +85,7 @@ hv_read_tsc_page_tsc(const struct ms_hyp
> > > >  	return mul_u64_u64_shr(*cur_tsc, scale, 64) + offset;
> > > >  }
> > > >
> > > > -static inline notrace u64
> > > > +static __always_inline notrace u64
> > > >  hv_read_tsc_page(const struct ms_hyperv_tsc_page *tsc_pg)
> > > >  {
> > > >  	u64 cur_tsc;
> > >
> > > Hyper-V folks!
> > >
> > > While reviewing all this I found the following 'gem':
> > >
> > > hv_init_clocksource()
> > >   hv_setup_sched_clock()
> > >     paravirt_set_sched_clock(read_hv_sched_clock_msr)
> > >
> > > read_hv_sched_clock_msr() [notrace]
> > >   read_hv_clock_msr()     [notrace]
> > >     hv_get_register()      *traced*
> > >       hv_get_non_nested_register() ...
> > >         hv_ghcb_msr_read()
> > > 	  WARN_ON(in_nmi())
> > > 	  ...
> > > 	  local_irq_save()
> > >
> > >
> > > Note that:
> > >
> > >  a) sched_clock() is used in NMI context a *LOT*
> > >  b) sched_clock() is notrace (or even noinstr with these patches)
> > >     and local_irq_save() implies tracing
> > >
> >
> > Tianyu and Michael, what's your thought on this?
> >
> > Is the MSR-based GHCB usable at this point?
> >
> > What other clock source can be used?
>=20
> You do have TSC support -- which is what I fixed for you. It's just the
> whole MSR thing that is comically broken.
>=20
> You could do a read_hv_clock_msr() implementation using
> __rdmsr() and add some sanity checking that anything GHCB using (SEV?)
> *will* use TSC.
>=20
> Anyway, will you guys do that, or should I pull out the chainsaw and fix
> it for you?

Peter -- I'll work on a fix.  But it will be the first half of next week be=
fore
I can do it.

Michael
