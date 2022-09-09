Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B555B2E81
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 08:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiIIGIY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 02:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiIIGIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 02:08:18 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F84FF525;
        Thu,  8 Sep 2022 23:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662703697; x=1694239697;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=v8lbQrMa8bcsGgGDXQVEe/LzOcH9KQQS1doYFFOiA6I=;
  b=e8z5qH35bVSAEsJFb4QQ/bknHU+vhlbCRbkFMAY50xhx3OdbBOStohoV
   6xOwa/x+U9WEOyz/00PE1MjtoNxjf3EyyboJqZ6hSKFvQ1ru9vcTNEqg+
   Lzd6FvvfQdJrxOWG68LdCaU8tmnHiFJwMQgkRUWZvfArd9JwRiHmu3wtA
   FMExyQ7DxGGCH8NWXVfZMW8sx0jYNTg8a8Wytu3xWS0BybbOyqQCtFtIX
   gAEnw9ATFekmLV6dEEOG0T1j0dLEPnYfmeq5NULsyWPYD0V5Hmyy9wsgf
   pLTDoR7CpbdHVXlefAsJnQl57l27M8Wp2cJ50Z5DqI0J6v5n4GBPXdwv4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="383700435"
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="383700435"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 23:08:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="592492019"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 08 Sep 2022 23:08:15 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Sep 2022 23:08:14 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Sep 2022 23:08:14 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 8 Sep 2022 23:08:14 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 8 Sep 2022 23:08:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvFxWB7e7D3O+8jRBg6/6CSj2V09Y8SzYr5/OoYJdqnDijmtuXMQkpKvvQtT/7BPGjBBV4+iCVeqQyd9qXWjvJdWC8sQUtXz/I3h2Srqr5vl2dbo/nhsYxiXM62e/0xLcSLaOkbY9bPYtq27l4i9JMB5hEvw3Ozu52gAlA+lxVMxm3p+uCeZBECENELZkFsCX9Mf4wzG3eVrvTK6SCBB/fl22Si0UeJmbSXTKbSMC0w/mXx5vY+04ZcMUzAqUCMt+Xqu+Zdy/aGK8N/lkuYHoeEJj5+qA1ROebqmqZJOO/piWIPAcFFdeRHWeG6wEFACwcf5pmT3TpTJut4andphiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7aiIFZAActGRYlB7lUyhi0UT28hl2mQ7J+JSkpnflk0=;
 b=QoFy608wHzoCmoNh6q/7FXpo3SwT7YVBHwTk89kfdlDJnnA65EiHjlCHrYSjPnIXtrdQYmh6YsGo7n+dNr10se4RhOSAfSceYM8GgVRZUwXHxAmzNwYkrTq5PPQBz+P4wdFY6McXoikVNbUvqCPbVTTp0PogcCAFapkENYRQg2Vfqng7l6RneyaDmac9JpZaYQLpIdqFobrmIl8U6SC+0cyHjAgqsuMk6zhfg7MKHFDWcFDRzwEjNqi8NQHbjSoU22Cg6HLDttbVQk+EQfIqHG3zp6ffu+TtHUHUvyqfgYSXtPJBU/l68Oo4zDIBz1KSQ9+iuTPdI6OO3sr0pciApw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by CO1PR11MB4946.namprd11.prod.outlook.com
 (2603:10b6:303:9e::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Fri, 9 Sep
 2022 06:08:11 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e%7]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 06:08:11 +0000
Date:   Fri, 9 Sep 2022 14:08:04 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     <isaku.yamahata@intel.com>
CC:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        <isaku.yamahata@gmail.com>, Kai Huang <kai.huang@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Huang Ying" <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: Re: [PATCH v4 13/26] KVM: Add arch hook when VM is added/deleted
Message-ID: <YxrYRKeU/AfCVJFO@gao-cwp>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
 <acc9a44a5626fa8d64690f3f6fcca6e85f6536cb.1662679124.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <acc9a44a5626fa8d64690f3f6fcca6e85f6536cb.1662679124.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2PR04CA0194.apcprd04.prod.outlook.com
 (2603:1096:4:14::32) To MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2221:EE_|CO1PR11MB4946:EE_
X-MS-Office365-Filtering-Correlation-Id: 56a1d20f-7928-4dbc-5a32-08da9229ac48
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gvtoi6xvF9Sh2qfvw1rbpepoEwakrwBF5kWv/k8S0IxJpBj4VIZJqoNqj6+6qty7YIcUFS1SGy6p7/8HfojpchIE/BrwTZxRw8oSlPI4qLH7/ffA8ydeLcqAA6dKukZeMuUC9GEeD72eODV8Lq9AMRMPhk+6NMbKX6eviU1xhmeBnDlDoPRS+J40p6vweXJ6nBMbtrGqo1lyHNZDzGIF/y+RAQM62GGcgpXeKstF+4Bm+rectfyR2V/ANz6qqKfjObjXFGQVo69zghHhGGPY2EPE5afJc8ZElwYpZaPG1l1ps6IBHBawMyrQumKLzbgtfupo6k7nElPUPcbRlKhYF7sKMq4WvFA9Tokk2cTqKYWm9xmlc/BA7QPb8gSEtLdfvwo8AAc6yTH2SE/uXdwCoLWu3qZzAYIuP5IU1pZnVZ+NYNm85/hHwMsnLk0C7gmuWcedSMJYG6KJcd+QWXeaOIl/tSoovokc4+9xCqYzxNo/i6zt4pFo0+/Cj9VUGS/g71WZ9BuVJpk4ZK7qKmjOMGNMMfZ85exKWJIvthqah4lLvwWXW7I1RYWUXVFmMj2Aan9GDpd4UopLtkQr949g+GQhTQ9BX8BYLok7FGsz2E29dIayxY59Ypiy7xiVjaX87tKGtY3dYSDE5gPw/bHSwY0G8hSaHl2rNp+jrJSODsXPixPRlxEWriOmSF/zMRYpFBUGLY5e72XIOL8nOU16Ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(366004)(346002)(39860400002)(136003)(376002)(2906002)(34206002)(8936002)(8676002)(7416002)(186003)(5660300002)(38100700002)(41300700001)(6666004)(86362001)(4326008)(83380400001)(44832011)(66946007)(82960400001)(66556008)(33716001)(66476007)(4744005)(478600001)(6486002)(6506007)(9686003)(6512007)(54906003)(26005)(6636002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jb2nGsmvNGoxU/hHOiPeS5PNuU6O00hE5cnfUmUNVkrc8pcQsvjJT9OCtXR9?=
 =?us-ascii?Q?0YCMpMQzihRknB9jF5XKKojFUHQy/eAKwqexQgI+wpE3dZywBpLYfwqNrM3k?=
 =?us-ascii?Q?ItYAbPdFMd0FIh/DHUAP4XFX4QrvWASYTqv2Dt4HD5zigKI3Nh4aaYntN4MX?=
 =?us-ascii?Q?TfWSpUXDB69deQYxn2t2nWJ6W6sPTagt4pyW/katWnlTtDrttHh8L09WCmt9?=
 =?us-ascii?Q?/qa8rxoREMsLWTqsb+4FLrI0fFw5cWyVAaF4whLCSx01r9DPZB3bLUYShvCx?=
 =?us-ascii?Q?zDt5djCQzRgXdFwDJKS/7FRN+x//EB/KTYJxTu4zV1fyWJLTdoVemEEQaNk3?=
 =?us-ascii?Q?eg/3f/bZVvje9W4bnXbXeJUe1QHa8pDRPwQcrpU+X9cLR1YvQJ7Ubhi084zU?=
 =?us-ascii?Q?dY9u5xV+0fjuIoXx4miXR9aLHir60Z8HSiw/3sq61dDGKtHW2wnISXU81WQ0?=
 =?us-ascii?Q?WmNGZS4Pd+4cr+Ul2PpdgVmHBWh/uRGXqA0I7vAqIXI62ofYpVf8dIvmNCRa?=
 =?us-ascii?Q?jan2xBUzjcWQ30b2JOSlOSWkL/YG9VHzJM0WlagUqkDd/d5BizbFMeMtJuov?=
 =?us-ascii?Q?Kfv8O0vO3TNCQ3iL4dqIs53uM3tyFJxK8z3b59n1Mdy3B4cNvpQ4qooCI9nj?=
 =?us-ascii?Q?MKOWG82ziRZ0hOSzcq6leh2Qxq9A+kU7BlcHdpogI/Jvm7kTjO8kVgvtHoze?=
 =?us-ascii?Q?cncbv7CDCgzsm3Qj1rafhhiXamJg3bK4XaxxiyJwDNmQNDRG59fJ455IH1p/?=
 =?us-ascii?Q?2QD4lMl6m5SiEqOmbyDe9vAIG9KISimwZH3A1V3jvxUWI272FwYNYAdnFe1Q?=
 =?us-ascii?Q?QTCZQQTF56PRAi0jIQ6sY0OqvCvtz1GX2ijjKSGSnMuYE7ZDOeG9JuLc3Urf?=
 =?us-ascii?Q?ZPfiMTvROoMhuhr6GX6b1MTIyl00pzY4yq9qE1W1FX55UPVLAo6tytS4PPH0?=
 =?us-ascii?Q?3pgqaPmkHN9vSHvop0jB6q2bUfPYjvZZncQ/94Ry52bprqhg8unKGJgBwh0Q?=
 =?us-ascii?Q?v+SOgNpcvVaWpVUsRSZMEZ8aHmKDNGSGTd4sePTCJ6RpdBFzhjcT517bodCK?=
 =?us-ascii?Q?DJwJnC4KC7m8T+fXOttzUkjJ/QosgImreyrwacS1SZPYEhXhS1cPtpS0U5ME?=
 =?us-ascii?Q?RTb8cSUrtBpAji7HPjWEc62YyMfoGj1FyHlBHj0Vm5Ld0t7XMfVU8NcaOLUD?=
 =?us-ascii?Q?HXMyyxaMiN3+SXMCaHH5Jr1rZgyv9vLNUdrm6TUbQYgeC+AGjb8cmHxl7x/f?=
 =?us-ascii?Q?ys/OOvW+r3K+Bj9R1NsyhsjyQSYghEMgRhkJb4tH7lDZFg6NAB6kFZGvzcGt?=
 =?us-ascii?Q?xJXZZrmZrj3LvosU16EgVCD0qNVXimzJrP029IWvfW6VQrVdufrvIc21Y+Wi?=
 =?us-ascii?Q?A+AKiJy1uzVvMrV6DdXwJH82SnRJOHbEy5DIf3RvoizEd5mh6fRHcmEIxBnm?=
 =?us-ascii?Q?D/3pE8LNtbPUjXqqjImKn7n85l/mcYHuhoILqbwHMRdBjG6cPbuNFybScy9s?=
 =?us-ascii?Q?6yK2joXy5GWkSM0kVS9pD5DXdSry3WYhmw6m4iJQMtpd8taD0bcFFiFk+5XM?=
 =?us-ascii?Q?XZgqJtJ5HrCE+3abELJDH1+65h1RadqZN4mpb22e?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 56a1d20f-7928-4dbc-5a32-08da9229ac48
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 06:08:10.9021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NIMb76rTgnRXkmNkc7x8kuVbNA1VVhifKR4oqNXI/5l+fP3ilv57QJaHmMH2ITKz0eMz0thu8utNO7dsO15DPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4946
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 08, 2022 at 04:25:29PM -0700, isaku.yamahata@intel.com wrote:
>+__weak int kvm_arch_post_init_vm(struct kvm *kvm)

int __weak

>+{
>+	return 0;
>+}
>+
> /*
>  * Called after the VM is otherwise initialized, but just before adding it to
>  * the vm_list.
>  */
>-__weak int kvm_arch_post_init_vm(struct kvm *kvm)
>+__weak int kvm_arch_add_vm(struct kvm *kvm, int usage_count)
>+{
>+	return kvm_arch_post_init_vm(kvm);
>+}
>+
>+__weak int kvm_arch_del_vm(int usage_count)

ditto

>+static void kvm_del_vm(void)
>+{
>+	cpus_read_lock();
>+	mutex_lock(&kvm_lock);
>+	kvm_arch_del_vm(kvm_usage_count);
>+	mutex_unlock(&kvm_lock);
>+	cpus_read_unlock();

kvm_arch_del_vm() is an empty function now. I don't understand why
cpus_read_lock() is needed. Maybe add the lock when you fill up
kvm_arch_del_vm().
