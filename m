Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71ED51070D
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 20:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351790AbiDZSfL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 14:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351543AbiDZSfJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 14:35:09 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020026.outbound.protection.outlook.com [52.101.61.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFF72982C;
        Tue, 26 Apr 2022 11:32:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jqIH1tqRDe/qhwnyHCrIi6CcVaGa9SSY5vqdy7x49tLbdzw/YFZozULl6s5BHiWi7TRo0k+HeZBsetQT4OhI2vmuel+2eaQYrc4cUdYAdN0mtgNYt6LtNYqzC4b2tigicj2VM+1ggJHxUwQ0TQ1DFn0zG6I48OJW2r2grcNZlAYk0/tnrSM1gye5Tz6eplFvMz2KRSvXrq8jChtkL+V7IRqH6vvrichRWnXmQaNm1MSzZp9ZFmGwN6yO+O/bBIrSKTcOv5UKGjlUANyjwL8N6p4TX9+T4CbUzvER0Sv8PVLPgeyhnNZCPQAWnx351KBgFkUp6exTL8CWgIlYXybigg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s1hD7zUJjy0apFTR5J/F3dQGCv72r5cQZIUyf9Zb/SI=;
 b=elcoNnivYgNe6UJxmNJ1IJyzUZrZceJj+fvzS77SoHFGpu1r7IP/A9Ao8J7bS2ljQn01EBh33k+8935WJUhrOjaNILz0BvPwrh73kuzP83Lc+D7TWSXtzSBwYCyK5B721l2XBS5TqkwD6uHEkmIbz+ec9ZrTzO6dyQXVafRVAFuzpyB+W3DrJlUiDUh23BWGGFkkjSDL0lcdKdQtfj0LtPddk0hJXg6+8O+R7mS0Hiqf/frAOdO74jXULdyFf2WGn78I7t2tZ6jKJAiXVxqPR6if6jaxX6GiAn2B4nSDNrRRwvRjaQT0vCOKwZZvHASWgGvbYdWgVuqS184xkbZozw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s1hD7zUJjy0apFTR5J/F3dQGCv72r5cQZIUyf9Zb/SI=;
 b=ZUaDokJvQMOB7WSa1mM/3p4fcKxBvWFBDvCkDHPGYd7ak4H0jbL8ToWL3IQfJQtpEWI9LlF80aBkUnUFNcZzgDLGkQRVupoWLdS7rOGAk7GiydoSZN2EuzlKuCYb9S+l9EtGBXnN+74zVSbOTvDE+jE3p/RM8VY9wthklPwc9lo=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by CY4PR21MB1272.namprd21.prod.outlook.com (2603:10b6:910:7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.4; Tue, 26 Apr
 2022 18:31:56 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::2823:3bd7:8a28:4203]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::2823:3bd7:8a28:4203%7]) with mapi id 15.20.5227.004; Tue, 26 Apr 2022
 18:31:56 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC:     Jake Oshins <jakeo@microsoft.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH] PCI: hv: Do not set PCI_COMMAND_MEMORY to reduce VM boot
 time
Thread-Topic: [PATCH] PCI: hv: Do not set PCI_COMMAND_MEMORY to reduce VM boot
 time
Thread-Index: AdhVrRvIeWjuo4jbQkC6t/9QZsLcgwD39GUAAANHMGA=
Date:   Tue, 26 Apr 2022 18:31:56 +0000
Message-ID: <BYAPR21MB127041D9BF1A4708B620BA30BFFB9@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <BYAPR21MB12705103ED8F2B7024A22438BFF49@BYAPR21MB1270.namprd21.prod.outlook.com>
 <YmgheiPOApuiLcK6@lpieralisi>
In-Reply-To: <YmgheiPOApuiLcK6@lpieralisi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4e64cf5a-7ee8-4ca3-9e7a-b567d41fc5e7;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-04-26T18:18:33Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8102f0fb-0f66-455a-8a1e-08da27b30b35
x-ms-traffictypediagnostic: CY4PR21MB1272:EE_
x-microsoft-antispam-prvs: <CY4PR21MB127212C3A20859F8BB1D5302BFFB9@CY4PR21MB1272.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VBP/WDJf7+aLFrN6sQaQD1SDxx89DUSkUC7mS0TnJBDHJIdj4x0UwBtwC823JzdJ8QxOgNCT1ye8t7G/ZzQPjAxCQMxZs5vuEO/TNL/6ADNtiC3wTLRoKigMUJqc2+qhAP5ZQvcF7EmactOV/+pYEBqHcxafrX3ttLLfqCGb2eH0Ugl3AkDdXPQMt1Lnt0ykPO/AUyakpnmAqMEeZ3kjDx5c0Py9w9NMh2QCQCdrP4woX5ytN0dwMAR7ApGLPIyexGy5a/kBsXQqhqgzbyokzi9csSlOtC9dTQ0S4wEqlavj07iM/rrlHwD94ZL55br3DOMV5XONzMh1D/QN6yWAw3teus8w48Dk7wiQiydSVuTyAEDWHGcFeQ1YaYR8CLRRvilQecVjFWzMJYWyMPWYbljyQcTDr0Hw5/0/aZU/1AYu2crM5R4xJYscpNcDDbfH/WeZFIbFo32JMGdzGOK8eR2jArXySNlmf6c6hzpMLeRUF9Ln/7jnQCgaGuUfCimzL1L/2ewzYq0bGsC6/2GcwxZ55PI9Hol0EAdsPjk8fMovXhHgC/ShiTgstyI8NEsbgCjwYKHzg1Tns+xBN64CpTacdxc4jGKD2+jNsEyJQvNuq531VmoGqDAOpOR3aUGxjOmIkWGoGbxVUM8G43F/n1z2pCgmNZEom8ITFi9D2Zk73Vex85mgjHcTqmLY3pbRFI/AsM6xQe/uInUxd2BZhhE/fItTzUspqdrp0NLVmzOT4DCUeTy9OKT/FZjqVnbS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(71200400001)(82950400001)(7696005)(55016003)(8676002)(66476007)(66446008)(76116006)(66946007)(4326008)(8990500004)(38100700002)(38070700005)(26005)(2906002)(9686003)(6506007)(33656002)(64756008)(66556008)(122000001)(8936002)(52536014)(7416002)(82960400001)(508600001)(10290500003)(5660300002)(6916009)(83380400001)(186003)(86362001)(316002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Lju1jlDijh6YHudx6uWGvoEwu5EEd53008jmvSoWEn9rGTDBKDCRxlCd5/g/?=
 =?us-ascii?Q?D03p95GXkrV4p/x2lNKRxSTLnKlSVmFcROSn7Tl6iPJYAtbsxpwQhCKBIzqz?=
 =?us-ascii?Q?V8kI5blMYlXVvK3O4N4rBFz+ySl1IS3Xd0uIPHU6V2ukZePqrD8Huz1StXeZ?=
 =?us-ascii?Q?ryxVBrSIY29D3Dbi8fAmvDAVM29bN3Zc6KqYQg8WSzmZEwqqRbP5l3nMgI8a?=
 =?us-ascii?Q?o1Qn6/2l77BquEp/xBl917YMVsbhNm76Gtwf3ZY3mzHTYU1zr63k8la0VNYT?=
 =?us-ascii?Q?7TpGG2o9Q4uCAIGQrnTzKUJOcpvKs42yx3TQl7ohlUsPz4OU1s79Gs+Lx/mY?=
 =?us-ascii?Q?xJPsmGTsIPEB1q8YjhXvP9iT7QDpVdMPWwwGzvy5IyYlnjAxCgDYQEJMIa4e?=
 =?us-ascii?Q?hQJQR8k+EnaQdKhaGJw41RMlvhRlhX4XeBawkAsoLzPCHMK8kwru2maaMWTD?=
 =?us-ascii?Q?vEvU464+3JNg2XnQnBGCb+qAfCeOz0jfJMUOOR6MgaWNrv5YJEp5a+r29jku?=
 =?us-ascii?Q?ni9kVcvvl/lUYebRO8uZ9JAyw3sHbKXS5r+E0NlQdgRSAEYx2x0VCN15olum?=
 =?us-ascii?Q?qEtMZr59Ym40vd/8H6srelDKZnMDSr3ZyVTX9OP91Zjb4wWlUzVA3fmvS33Q?=
 =?us-ascii?Q?TzvbsJZ3ONaWOykp+UO1AM+NdVjKVarcLTTUeAvn2DlQoc5Dij2gPzPiMBr5?=
 =?us-ascii?Q?xd8taz9WjVIlChZalo4FLemkhzaDZbP8jafUQZSWuw+c1ip+J6FslurLYZNq?=
 =?us-ascii?Q?R+GX+OUtzDtQpzP/kPSotfKqp6aHO0U1E5IpQrRMD3c1XNo7ylj5kCuT6c5z?=
 =?us-ascii?Q?D5i3y3sjOwEqkgFCeyvXDUdRzGXFjNyrkAAayv7r3Z5nmxZRl/qP4C2+kSOL?=
 =?us-ascii?Q?Egev7eAyxe+s/WDr8M3l4J5esIN2zmbh+Fw6r6MFwIBMQFT1+U1gETHCfG6U?=
 =?us-ascii?Q?NOxQA30VhkirmuSvfRi/h6KJlPHFAQUq+4sak0AMnm6Uyuzz8WLSP3oVIup+?=
 =?us-ascii?Q?CEnIOsJQF4OzodrzqMkQ7CY48wocjOb3znMFUfGPyyrM/NLNXLB06LTPhbTA?=
 =?us-ascii?Q?ZMoQHzJFZKdDfCsVuYSNZvqn8EvYp2uBEtnzWkhu/xcTBFdzDLZXFgCGayJb?=
 =?us-ascii?Q?pwyOafmdo6jeygYnwTQg/wzRexiKVYsIzMl4Q9EnNtMItlngcq6pk2ldZLXb?=
 =?us-ascii?Q?Go78JFUQnrJUVDLCqqdIliAjfKHKet4m9cFPiozrKhAKAcsuxruQijoV4jxW?=
 =?us-ascii?Q?YhJ/dhvADiPkyJMzGR46rcSbsipBFCZkH4LJCx4uk+AIdh6gQy+zCNe9FxkG?=
 =?us-ascii?Q?wgOTpDGm2ppwfTe7IYjPH87IdK2GPYiG2KLnYmQJPRs3+pRlwOFIB/sS108X?=
 =?us-ascii?Q?EQjYoBnXr8eTMsCwM53IuJg/2VKnvM73zYq91VLuq0MB4/o+GlXtq5XGYzzz?=
 =?us-ascii?Q?fdp6lkFI4JH8qGhdNWFB6rdVXquO0/M6UZD+JB22DtG/0DtBpx7mwdnxvS+x?=
 =?us-ascii?Q?h5a3IvyLuxM8o9bdUxK1entgjCXu9Nxfc5LDXI6vHC7iywg1jt9ZdREz5DPG?=
 =?us-ascii?Q?Zzxi0cshHvJdLnqH/DVvVUSnrUMWrj2qfTcL9qmggnCrwniXlCQkyoIiIWWr?=
 =?us-ascii?Q?YGZPf1M/8ek/Z5fTeIj6B/2MFqqy4r+waj3IYbm61nXaUBjittFfYRVnFoM4?=
 =?us-ascii?Q?B2XXyiiXVo8gGNivauw+CVaeFqMl8ci4sRjYWP5/3qsbRwlOmU6atrj+BH8S?=
 =?us-ascii?Q?D8OtrN21nA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8102f0fb-0f66-455a-8a1e-08da27b30b35
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2022 18:31:56.5983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0nYqXaTaUg1qHUXfgEt2fkloAixwz8bNC6ks3oH+OVgFdPTFFBjrq1rd35fxT1T3cxFxbGS+MoEsqG7iyd1Q6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR21MB1272
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Sent: Tuesday, April 26, 2022 9:45 AM
> > ...
> > Sorry I don't quite follow. pci-hyperv allocates MMIO for the bridge
> > window in hv_pci_allocate_bridge_windows() and registers the MMIO
> > ranges to the core PCI driver via pci_add_resource(), and later the
> > core PCI driver probes the bus/device(s), validates the BAR sizes and
> > the pre-initialized BAR values, and uses the BAR configuration. IMO
> > the whole process doesn't require the bit PCI_COMMAND_MEMORY to be
> > pre-set, and there should be no issue to delay setting the bit to a
> > PCI device device's .probe() -> pci_enable_device().
>=20
> IIUC you want to bootstrap devices with PCI_COMMAND_MEMORY clear
> (otherwise PCI core would toggle it on and off for eg BAR sizing).
>=20
> Is that correct ?

Yes, that's the exact purpose of this patch.

Do you see any potential architectural issue with the patch?=20
From my reading of the core PCI code, it looks like this should be safe.

Jake has some concerns that I don't quite follow.=20
@Jake, could you please explain the concerns with more details?

> If I read PCI core correctly PCI_COMMAND_MEMORY is obviously cleared
> only if it is set in the first place and that's what your patch is
> changing, namely you boostrap your devices with PCI_COMMAND_MEMORY
> clear so that PCI core does not touch it.

Yes, this is what exactly the patch is doing.

Thanks,
-- Dexuan
