Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023426A2163
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 19:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjBXSYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 13:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjBXSYh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 13:24:37 -0500
Received: from DM6FTOPR00CU001-vft-obe.outbound.protection.outlook.com (mail-cusazon11020017.outbound.protection.outlook.com [52.101.61.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215FA193E4;
        Fri, 24 Feb 2023 10:24:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHGMyINFkz+JTgqeFxy6hBTZtP9jHJouVskPZSexjiq1BnNxxjDtYrIbnn6TQKZ/VZhkAe6khXC2HRKrFVHKxRu7MkD2Gvsp6/W0M+ZsqDKmDzD8LlI8H5gO9saryL+7gdstyWQo8wgk1Em21nNFC/jUFxIQTV8I5lPkZrSnBtqzqchSpDxP99NRtDj439Le3mlfeUyjvLoR6qrSl0qwszEu6A8eRr2GIY9MEjyc5ufV7I+oBtcJV96921RK4NZlc5gGgCZN3avKB6rWQHGM+Ojt1A8EMkk6Zh6nSv1aE49MZ/RR8Pf0cxDWx28wYIX3kjxHGN45q3R7ZU8qVLS8fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ixfrm+R5oxjiXwK9HqLTqKgLQOLJ7bv14gyZCiiqS+o=;
 b=C83RR7NQ8RS6B/Exjuk1H1TIhr+wF09MfsQSwSHLi9J/Sj4M9tobcSnG7bIsS+eBLnpBhxl8z9knVNy4RGv5p/J/gX3MW0yL+vANXk92RnTmEmyyYBSOxlMGiM04iz6YanyzbAhmCGq/cpNVNhiEQTfBcK+6HRfkAsSnVnCOepUxO9NYJtObxq1awBOjmxkKRf9wG9St4fugXy/K00RkEEYHXlzgf1nygcRhA7NmLCAp8sIp40x+0Z4e/pkq0MgCLVWHnZ+j2l+QhhlJ29shZ0DTzDP4GGZ/9qH5tGtXpEOsvqTz7spEfuK2XgMsdlcR1Fnrbn9rPRTkulHwfijUuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ixfrm+R5oxjiXwK9HqLTqKgLQOLJ7bv14gyZCiiqS+o=;
 b=QHiQkxDHZnTLk8I9OPF+O8p0+0HAKjj2gCDahrAmq+IcNvKtzLUq+Ah0zce9AGdwlF4uds/oPZSALO+bC9pLMGNGydHx5R7WkV0g8zvtq2yX+50y5Z8ADeel3bODioKeNM6qNqryE05iFHOepmAZzHQPWn7jiZKtSBadFYJCNhs=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by SA0PR21MB1946.namprd21.prod.outlook.com (2603:10b6:806:e1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.11; Fri, 24 Feb
 2023 18:24:33 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::629a:b75a:482e:2d4a]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::629a:b75a:482e:2d4a%5]) with mapi id 15.20.6156.005; Fri, 24 Feb 2023
 18:24:33 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Usama Arif <usama.arif@bytedance.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kim.phillips@amd.com" <kim.phillips@amd.com>,
        "brgerst@gmail.com" <brgerst@gmail.com>
CC:     "piotrgorski@cachyos.org" <piotrgorski@cachyos.org>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "fam.zheng@bytedance.com" <fam.zheng@bytedance.com>,
        "punit.agrawal@bytedance.com" <punit.agrawal@bytedance.com>,
        "simon.evans@bytedance.com" <simon.evans@bytedance.com>,
        "liangma@liangbit.com" <liangma@liangbit.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: RE: [PATCH v11 09/12] x86/smpboot: Remove initial_stack on 64-bit
Thread-Topic: [PATCH v11 09/12] x86/smpboot: Remove initial_stack on 64-bit
Thread-Index: AQHZR7r/U8Vm6aigvUqzussh1qSlOK7eam4w
Date:   Fri, 24 Feb 2023 18:24:32 +0000
Message-ID: <BYAPR21MB1688FEE6BA7464980CCF7A21D7A89@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20230223191140.4155012-1-usama.arif@bytedance.com>
 <20230223191140.4155012-10-usama.arif@bytedance.com>
In-Reply-To: <20230223191140.4155012-10-usama.arif@bytedance.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=83ecf5fb-9690-4fe5-a0b2-1855c1d1b6d4;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-24T18:22:26Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|SA0PR21MB1946:EE_
x-ms-office365-filtering-correlation-id: d506cd89-e5c9-49f9-35c6-08db16946052
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b30Bg+Y82pQKWLgMuJD7AqQ5EIeD2JHs/hpl/nMgg65hLUuB2uklglilqwCstskBxbL4fELxWcRfQiPzeVcxguuzncbW8U1ePZxcwK2nX01CVoqmi7Sam7etRU7cPp1RjCqZZsTsVNkPP/xnMD4JOvYoPWDLiHvtcOn5Lvuc3XwdQdaeDoooISIW3dAOeV//OxfUku8It7B19sQSmTp3XSY62EC9LGsAxruamn3rnCOIzrsfaA5lOleqTV+QNpFEwD7xuS6RO71vD4hB9zs4nGNwlRCIpk9+Y842gkM5CzCzNRJIYGQ0wPlz0XzOyhoIHRTT3aG0WBaNySsxtaqqy7ue1N9m1Bj74ukDgQ1WY+0st33xBtsqMUrGlL0+RA0D4jrFXzdCpf37KV26Dm9u3cYrKap5HiElCjuvUeFanJLRFSXHMUKtcBh8O3psO7Pv9KvDIuPLPJn52iQ/gclZr8ENuqvtttitQ7dc7MN2AjJ8jSJFBQ4FZ4PuDfbZqNq7s+MV5/I+dbLt9OoBHcwedlqHY9+kKC413Tw7FacM0WCqxOcUPA2TiwAOoG25pBp++42UqLEOGo+ZS0vI0cne0vkoUtmJuFbL5T/Gr6zPWzzs9QTaVZrN27gI3WL2fV7UWsXPw6XqatLVkL6A3we4R/WHbC0Cfwu72ImDfSrXXyZy81jEHz1P+auWkwrY7Od5UMF4kixCXgveDbSO1K4AUJj3NolBOZV1+QeMtCvR6+pugBFKvqNXLstT7zp028/8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(451199018)(83380400001)(64756008)(38100700002)(52536014)(82950400001)(8936002)(71200400001)(5660300002)(7696005)(82960400001)(122000001)(478600001)(7416002)(66446008)(38070700005)(86362001)(55016003)(33656002)(186003)(26005)(6506007)(8990500004)(2906002)(4326008)(66946007)(66556008)(66476007)(10290500003)(8676002)(76116006)(316002)(9686003)(54906003)(110136005)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DMqGrfhaTL4eSS6/XXGoujc3TNiEBQnPMyW5jY1zG+R0bbxITaY1DsjJJ4tF?=
 =?us-ascii?Q?or5qkZvzHhJznaYNU0lJYxB4L4paytUYaUDfqc2owNRHSyzeN0WtHyerbkSs?=
 =?us-ascii?Q?zvVV/CKKN/UewCytW3IBDbsqfh9CZwGztXPlzHcYIu4LCEMtUCJd345NyybW?=
 =?us-ascii?Q?5Z7yn0idFJdAz5ZIFvzrgYCpUOOHB4sPqQ8GhIOFkfzZ7mfwC5OWWdlO3Tj+?=
 =?us-ascii?Q?vv1pJkbKyp3lTC2As7PXarMUQ70M9RSzpGi8Mz+zUTCogYWRrIyTnbn5xuYD?=
 =?us-ascii?Q?TUUM1XENZdHcxmerqblv00nM92vR9ZBk5nu00ubLDkX0oQOaKPzqrYi2ZI7v?=
 =?us-ascii?Q?6FSMn178+7xO4Zsjb9ln3XvDysKznxDXVXz4dErI7JY20CR25rJsADU15dL9?=
 =?us-ascii?Q?qipLu5xfDAUE8MAuU988qOFZCiMDmRHJJ0R4e3DWbcpXTvO/LscMtL+syknx?=
 =?us-ascii?Q?hDbR2++RSu/3ZKnhPSLOImJHJK5iSwN9JYiOGdOviIirUFMkL7ZBMmM/KLsm?=
 =?us-ascii?Q?fUZaVpo8Tig89TQc5pcXx+ncboixPcD5q7SyRM23UdP2DBpUqqROYMQ5ZsuG?=
 =?us-ascii?Q?LUVHSOgf5RgjvL33J/CPzYBS6RWF6pK3lGaSQgX7xyiBoCVm1DOJgcQt5dgW?=
 =?us-ascii?Q?/fblMhniSmOe1tWbBzrETnmFXZrmGqR1ueVn9HC5AnYjQYuuXJ9rtKcD9463?=
 =?us-ascii?Q?yJOwWURPegHdq7Krqc31j3HPzFr5BkAbnXPwtKIncxYYeKPxnleE0HzKK2hO?=
 =?us-ascii?Q?Q9JgLMkFON+Pw8k9DRGHx8JKM7hQzeaZlTMAfBco1tyvlR6m8/msp/PNKg/t?=
 =?us-ascii?Q?wYikWWoG6z9Q7TJFrz9LSTHxWb2vB/b56yFSyPdu/373oS4/JnqWt6fJ3mMa?=
 =?us-ascii?Q?CzxkfTtTyEKZgkuKVFcyuzJEPqWXCoyftbuUfl8jUltOACRMcwKiJjR+Mt0d?=
 =?us-ascii?Q?Hev/K61oyTmr1U5sKgR02SLS2AW5KBIXoWS1oz1G1Fh7FUMV6u/eReU6Sb37?=
 =?us-ascii?Q?JZSjENgj9ZEYY/X0AbXiURCetDgkEyflhDIcHNNmwEUqc608zT1IhUGbmUcP?=
 =?us-ascii?Q?YGUdZTFFkbqD8anv4e6fU0FjXJlkWhQzx4wyDVgFoe+6WBv8Gr81M+ZfNnUe?=
 =?us-ascii?Q?oxEy9zuI2/X0LpLyCPKKY+pRFai2EVEKVYjGPHe4YXGkfN48bunwJQzZqwO0?=
 =?us-ascii?Q?9k+bxL0MhIkChlVZ9SV/sbAMz0ZcwIO2eRFSJUbC90NOFxC7H9LpkVI9YmEn?=
 =?us-ascii?Q?Trt9ruhsrT36DzHs+qioz8v+SSSuTQ06eK97CUV2xXY7l6Vvp9L3XBd9cASm?=
 =?us-ascii?Q?6WfT/QtX/R6wC9Mgi+kVQTBvgk2TrHQR/nGQABD2AeroNFiegwm3QsRd3CMT?=
 =?us-ascii?Q?3MNL/tLm36iQSUxf3jUp2AIxhaS9YQR1UqwxL+MqEx6Dh/fRhwXxmPm7ZTEM?=
 =?us-ascii?Q?EHyCzVkp3R8o7fja2pjqfrLf0ReWatUqfIpbeeR5zKh9RyuMQ0phRJUhdsm2?=
 =?us-ascii?Q?Bgf5+SVGQA/6M3xT09ySV4UyMFJCZDTIHieSutUOqMjfZ9WfEAXQEFPENnyY?=
 =?us-ascii?Q?OjWXLnUz1H7bMtUdADPftwm6z3ExZaEZzYixndvOo8k26dwNoGFWwn7e/9WM?=
 =?us-ascii?Q?cQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d506cd89-e5c9-49f9-35c6-08db16946052
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2023 18:24:32.9559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eWKw9gJ0vvfPqbr6lSxQjGKFHvrs1LxK4sKH1tgqbPOZmpxC2EJG2d8ov6sLevYp0xounraoVfxJyIM47SVFLyNjw+JzMsbWfXXDuCXNRyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR21MB1946
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Usama Arif <usama.arif@bytedance.com> Sent: Thursday, February 23, 20=
23 11:12 AM
>=20
> From: Brian Gerst <brgerst@gmail.com>
>=20
> Load RSP from current_task->thread.sp instead.
>=20
> Signed-off-by: Brian Gerst <brgerst@gmail.com>
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Tested-by: Usama Arif <usama.arif@bytedance.com>
> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
> ---
>  arch/x86/include/asm/processor.h |  6 +++++-
>  arch/x86/kernel/acpi/sleep.c     |  2 +-
>  arch/x86/kernel/head_64.S        | 35 ++++++++++++++++++--------------
>  arch/x86/xen/xen-head.S          |  2 +-
>  4 files changed, 27 insertions(+), 18 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/proc=
essor.h
> index 4e35c66edeb7..9c4a5c4d46c1 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -648,7 +648,11 @@ static inline void spin_lock_prefetch(const void *x)
>  #define KSTK_ESP(task)		(task_pt_regs(task)->sp)
>=20
>  #else
> -#define INIT_THREAD { }
> +extern unsigned long __end_init_task[];
> +
> +#define INIT_THREAD {							\
> +	.sp	=3D (unsigned long)&__end_init_task - PTREGS_SIZE,	\
> +}

I'm getting a compile error on the new reference to PTREGS_SIZE:

In file included from ./arch/x86/include/asm/cpufeature.h:5:0,
                 from ./arch/x86/include/asm/thread_info.h:53,
                 from ./include/linux/thread_info.h:60,
                 from ./arch/x86/include/asm/preempt.h:9,
                 from ./include/linux/preempt.h:78,
                 from ./include/linux/rcupdate.h:27,
                 from ./include/linux/init_task.h:5,
                 from init/init_task.c:2:
./arch/x86/include/asm/processor.h:654:42: error: 'PTREGS_SIZE' undeclared =
here (not in a function); did you mean 'TLS_SIZE'?
  .sp =3D (unsigned long)&__end_init_task - PTREGS_SIZE, \
                                          ^
init/init_task.c:115:13: note: in expansion of macro 'INIT_THREAD'
  .thread  =3D INIT_THREAD,
             ^~~~~~~~~~~
scripts/Makefile.build:252: recipe for target 'init/init_task.o' failed

Michael
