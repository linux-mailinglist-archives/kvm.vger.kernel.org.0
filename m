Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9655E7559A0
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 04:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbjGQCfm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jul 2023 22:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjGQCfl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jul 2023 22:35:41 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11olkn2010.outbound.protection.outlook.com [40.92.20.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0097A4;
        Sun, 16 Jul 2023 19:35:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qr8blcAbpbIRZfWkuvBW0y6VFtJiLBgoraeq5fPd2+EPhntORm2T7J5jYKDYLXzoBnp8esEiHga0OwoCOHtUE7qJRsDLg6oP5CtTPFD3hE06uJf9yPBz8ta9DtuYDVewwv/pXxm6kZgF5kuzHOCKsbX4os+RTYao3VYEVcWMNSiwamx521lQTzZvw1l2T90GRp/DEjByCgRN1nNyEVZkF+LII8mGMdTYhCU3ftq3m56QCh9vDIEbBxu9YFk/UTx/UYqgpS9jHLmvM44dZZbl4+TFn9zScxA6Uu8FzftHkdPK3RFMBT6oZe/GyE0HRv3OYCC5QfAfTU2gAiBwZtGXTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=85NxUleXUSI6sfV5cSd47W4WsM2nWzIPHbNgwyQ/MQQ=;
 b=ccogBHxfIXqPFPp0+GXgDiCirtb5bUZwHjygfcrL806j4eQuPwTzFP3xrdd/qAJv4PKH1ki/DdyaBDF65puf0kqfuFdwMTm/vLyr6C2MFVStAivdvtLaFzNMDUKwCa1AcN5lO9sL9m0P/6y4Z5Ac0vbZsJYMoUW++EjGZv6CQqnMUiO2FusCVG73v/v/mL8jJzq2tDg+FZGJV9ahz1RMJi2fsydSeycEA0rlX/qMBNrkunaj5TYvylmtqCNVAH86qB7uueQ8pCrkE/QWazzWmsEchsZ7hIF2Ezjo7gpfB65kXUsuAiRP6lPgD/qK0EihNGkl9tWdHQYR9ML0UaTSfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85NxUleXUSI6sfV5cSd47W4WsM2nWzIPHbNgwyQ/MQQ=;
 b=dz7MBzXlZbF7G7oUheBEH/BP54zRjOH1Fba6403u4ML9MXTLmDXopTn4o0HSWl5GT6zE1eS5H8nHXnUWsFmNqY8zV9o4yZmZdFinlaPFVtiHeE1TmvDEIiVdWwpDkDK/Ff5jArn13Y4mrIT6x1Ar7sNR+txK7ZVB7vpk1657UoZw/4eKEXiTb0f6H7aWYgSu+oxeKrEPXRdlm1FywbSNjpCecFZTS/uCOyVwbjddaHF+ShF7L6TWLn1dluN0+Z78hSO5pqOZ9E4xmGx2EYfJHXquGQtx79/NiwynqBkJkhVSfw+t4Pfbzfp9n9RVpXHP17O+uX25lWpupGkj+DAUwQ==
Received: from BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
 by PH0PR03MB6512.namprd03.prod.outlook.com (2603:10b6:510:be::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32; Mon, 17 Jul
 2023 02:35:37 +0000
Received: from BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::d952:a79b:d824:3b0]) by BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::d952:a79b:d824:3b0%4]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 02:35:37 +0000
From:   Wang Jianchao <jianchwa@outlook.com>
To:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     arkinjob@outlook.com, zhi.wang.linux@gmail.com,
        xiaoyao.li@intel.com, linux-kernel@vger.kernel.org
Subject: [RFC V3 0/6] KVM: x86: introduce pv feature lazy tscdeadline
Date:   Mon, 17 Jul 2023 10:35:17 +0800
Message-ID: <BYAPR03MB413308E4D2F2D75CA199D177CD3BA@BYAPR03MB4133.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-TMN:  [CwMM1HamjbpE+ij3grKI665qj4cwNLcgyrzNwRYLXmw=]
X-ClientProxiedBy: SI2P153CA0023.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::6)
 To BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
X-Microsoft-Original-Message-ID: <1689561323-3695-1-git-send-email-jianchwa@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB4133:EE_|PH0PR03MB6512:EE_
X-MS-Office365-Filtering-Correlation-Id: ece179ff-0343-4b09-4be7-08db866e80a4
X-MS-Exchange-SLBlob-MailProps: Cq7lScuPrnqpUrHVo6HYXI9uowj33ZBSmQQb5mmCbwe8mfm0oQGb12XuD4EHYSTPOeZH8A1MSItIPXAz8LPB6Ypk2s4tc0WLhBhXj64TNPmy4axiYvra9IkLhyoIAham2Ya3I+dL2EvJ7/UwO4RZTveRUCtcXgkblYw/dpv5zwqlyBuvwjKN6vnO9whxkDJAbOlSU4UZF/aGC7f2dDL0BQLZ9VN8AyDaAX+hu3ZjmlUnL7L3UeTIw1Ec+/oBnZql/7PSrl1tCzzLO4z9v0D14CQRNBbX96tnHGyadWpy10doYnaX8JEkwEkTXUWn4ahUdhNcb5SAFc6wjYplOOpquDmgirUvLM2Kjbh2ZfM6WAWr8HuxFBhBozUhAhYA0900HGT64EPYomFoh8hO15n6zUCquTPIX2lLAKCBhdwaqvn+ghraV3gqEqz7KMHNhnVD0ZwAu1ohOFXrG5ZXIiCK8mOlHzDJjL5fATd9SZxeDCNHX2bZJIGaJr+nRtIih0ABTLsc1n9fYYkPLeKVer/Sko7ajSu1Zoqib9r9BL6s0/HNvQNQ7/n1piKKn8fJFHo4RE+Zeopxd86vKPVMHS17lcHZ6e74iuX8CL4ZP79u2E+i6f/CJayKpZAkXzgGhkYZzbIf28hWOpGnMuwobdN7yaEZzF6wj0GWZPS0BpKO+IjjeV4T+LsntSAZD4yty2VRgE9HcL7Nx1VCHPcs0UVEaIqg24/9L+JNAXrHxuEvNANnc6jI10H5QzCahutIdhe0/PRstCAR+kc=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TV5xlAMz2xA1l8gZINurYu2R1KEitmkN0zJgj4e1+XMhSea7AuNZigvd9v2OV5v15b/AJJw9RazBDcxjQKjRVA7OdNVfVBzU5jrRkk55iCQiHD1/L/8DSXoakBvG3LXgW4RJbnpUg9xJLp41yJ/VODa9slLM1Ot7fcJpYyuY4CEl5yLd/+vne8kjg/PeDi/CtTwvjw7ZV8NQH+QNn+nEmM4+W+aTRsU5Tu1PwyEs5U+9p4vgkl9cnNl+jCe2xxMJnIOgI2IXj77JZ+bAA9pF3yI0kfqP0Zd8gAf0ayHAtBpfatFUucj4RA77mXIgGhN1CIPrm2DHeGqNW75SmPa0X73C4q15o9o/jHyM7/TqtxbYSKQGIY5F59fdMWy3zy+NVHR45Zezkaf20hFcoXx5Q39AotVzAD006fS1ahTErp6+MJA9YdcSojeXEhf5RODcpH7sMPiLGurtBBe+80fHo85XxqJw+XL3avzzR43OYC3GAppS3S+ssC+p0CbPN9e0hGVjRN/yOhQtk5JGd/4O6qoC+ghlMu0MgE2WdFwch7oI1Lc9ta9UdIoEpTiFgKfl
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jArduiL9gq5Jsp7edp4nd66N4PxL8i3eh3ul3mN2A/wBGt/vxrxrTzAJivsw?=
 =?us-ascii?Q?HMBllfBtSJ0W0quKWeYBf9RpzGxX5XNh+J/GUkkOjeoKu6gif9cDconPdIzR?=
 =?us-ascii?Q?ugbPz1HA0u7W/fZobcgCfNMNW9n4BqHMOLtw5H6yXtSWLUggus3CPfz/xS34?=
 =?us-ascii?Q?JPoBnxvtY8HKYGNF9thX+Q9SNi7Gi4ldt8hvAWVUOJxop9VEqfkqIvNjcQ4/?=
 =?us-ascii?Q?JR409SpyjamrSI7rKJslLLZxKd4E/6hVSRX92+kJjs9nCKtk00OaDq0ulKwW?=
 =?us-ascii?Q?xZrrGq2JxscFy61Ew54ci4Rt4acOl7v2udI/1zg8Z0NZY2bpC38AbfcUq+Qs?=
 =?us-ascii?Q?1DZGwIKFnESYfcqG5KEb7/KJeH6jk4Yc4L0LfvLNSCF/1kTIz3ycjSMfD/do?=
 =?us-ascii?Q?7EL3Lhy5OGjHLvZjfJ53a4Z1QpGCo9ov7+7X+TGVr8HHs/dCpJneNQxcGnT7?=
 =?us-ascii?Q?H1QVTIfQQMid+E/V7uw8WRa/GrIm0/EYb5IL+nKUBB/BK8AO9AHsaI+f0Qxw?=
 =?us-ascii?Q?l9Q72MGc6LfdAi4erWfdlvSI9su91w08Ha5ieEbE32QovD3d+niJtRnYhD/9?=
 =?us-ascii?Q?iu5F2QcfQlAZE8zU7z3l8ezpIen2VqHPstTmqIDbHf6E9E3TWOvszfz6Ds9Y?=
 =?us-ascii?Q?zzsLJUTLVneCLNiGUnPZ+mLOqBjYGvxRNxxViIrAjDFCv3yI1cOivpVIUp2x?=
 =?us-ascii?Q?9lcfTeTpxK3wyYVbVYhZpk/cR+Mr8qY84HfkyFzQ7gutwcySKjPqGV6GBbVh?=
 =?us-ascii?Q?A6ZqNEkW1uzyIWWtzCgBKcrPWHG2g5yIaentY2gey+lXghFn78skT0ocFM0W?=
 =?us-ascii?Q?AbmllPtf/6cetQK1QVVcwLnYJEhGHxM0FI23LPIy6uSfKeIb10P2timfs3j0?=
 =?us-ascii?Q?8kYwa7v6WZM8u49E8k71XOZ5SPKnWjXiTgG5HBLRNiTgRl5gpNhGxWi7xBnj?=
 =?us-ascii?Q?bFV2rEHpQOlU8na76fs1h8usD/K9BuRmlsc19uieroS/No0TTt18zbnMW3Rf?=
 =?us-ascii?Q?cR5lyJymQ1RTxqVSPeXc4daWdOilYE6BVWLL7PRlCXNxSRmnB7i/FT2zISpz?=
 =?us-ascii?Q?edBIscSIMaiNNcbACB/Tx3fQW2sYKiL5onwBETerTaxJ4tTrSSGa/qW3bWdc?=
 =?us-ascii?Q?xkHB9DIuCfRfmou16xof3hk7/g9PYzHfE4zOpNUMqKyyZPyYkG/GxH0HtFEl?=
 =?us-ascii?Q?diIc/3Yw1uJpVB6kXRWzdW0dWJfrV52CUga3hWg0NbYTgzPaTOL3oCNSQqc?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ece179ff-0343-4b09-4be7-08db866e80a4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4133.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 02:35:37.0673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR03MB6512
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi

This patchset attemps to introduce a new pv feature, lazy tscdeadline.

Before this patch, every time guest start or modify a hrtimer, we need to write the msr of tsc deadline,
a vm-exit occurs and host arms a hv or sw timer for it.

w: write msr
x: vm-exit
t: hv or sw timer

Guest
         w       
--------------------------------------->  Time  
Host     x              t         
 

However, in some workload that needs setup timer frequently, msr of tscdeadline is usually overwritten
many times before the timer expires. And every time we modify the tscdeadline, a vm-exit ocurrs


1. write to msr with t0

Guest
         w1      
---------------------------------------->  Time  
Host     x1            t1

 
2. write to msr with t2
Guest
             w2 
------------------------------------------>  Time  
Host         x2          t1->t2


2. write to msr with t3
Guest
                w3         
------------------------------------------>  Time  
Host            x3          t2->t3
 

3. write to msr with t4
Guest
                    w4        
------------------------------------------>  Time  
Host                x4           t3->t4


What this patch want to do is to eliminate the vm-exit of x2 x3 and x4 as following,


Firstly, we have two fields shared between guest and host as other pv features, saying,
 - armed, the value of tscdeadline that has a timer in host side, only updated by __host__ side
   Everytime the host side arm timer of tscdeadline mode, it update @armed
 - pending, the next value of tscdeadline, only updated by __guest__ side.  Everytime the guest
  invoke kvm_lapic_next_deadline (lazy_tscdeadline version set_next_event callback), it updates
  the @pending no matter jumps to wrmsrl

In guest side, saying we want to set tscdeadline to t, we needs to update @pending first, then, 
 - if @armed is zero, or t < @armed, jumps to wrmsrl to trap int host to arm the timer
 - if t >= @armed, just returns

In host side,
 - if @pending == @armed, inject local timer interrupt
 - if @pending > @armed, just re-arm the timer
 - there shouldn't be case @pending < @armed, the guest side will trap into host to update @armed
   in this case

1. write to msr with t1

             armed   : t1
             pending : t1
Guest
         w1
---------------------------------------->  Time  
Host     x1             t1

vm-exit occurs and arms a timer for t1 in host side

 
2. write to msr with t2

             armed   : t1
             pending : t2

Guest
             w2         
------------------------------------------>  Time  
Host                     t1

the value of tsc deadline that has been armed, namely t1, is smaller than t2, needn't to write
to msr but just update pending


3. write to msr with t3

             armed   : t1
             pending : t3
 
Guest
                w3  
------------------------------------------>  Time  
Host                      t1
 
Similar with step 2, just update pending field with t3, no vm-exit


4.  write to msr with t4

             armed   : t1
             pending : t4

Guest
                    w4        
------------------------------------------>  Time  
Host                       t1
Similar with step 2, just update pending field with t4, no vm-exit


5.  t1 expires, arm t4

             armed   : t4
             pending : t4


Guest
                            
------------------------------------------>  Time  
Host                       t1  ------> t4

t1 is fired, it checks the pending field and re-arm a timer based on it.

In this case, the vm-exit caused by writing msr of tsc deadline for t2 t3 t4
is reduced. Even thougth t1 causes another vm-exit of preemption-timer, but
we win 2 in this case.

Here is the test results of netperf TCP-RR on loopback:

VM-Exit:                    Close       Open
                sum      10485133    6177331
                halt	  2082894    2958096
           msr-write	  8323993    3140474
    preemption-timer	    36036      42064
-------------------------------------------
MSR:
                sum       8324075    3140518
            apic-icr      2115802    2969154
        tsc-deadline	  6208273     171364
---------------------------------------------
Intrrupts:
                236         44003      55059
                251       2081941    2943361

Note:
  - Host kernel is 6.5-rc1
  - Guest kernel is 5.14 + patch

This patchset includes 6 patches,

The 1st patch, KVM: x86: add msr register and data structure for lazy tscdeadline
add msr register, feature flag and data structure for this new feature. There is
no functional changes in this patch.

The 2nd patch, KVM: x86: exchange info about lazy_tscdeadline with msr
Exchange the gpa of kvm_lazy_tscdeadline data structure between gust and
host.

The 3rd patch, x86/apic: switch set_next_event to lazy tscdeadline version
If lazy_tscdeadline is enabled, switch the set_next_event callback from
lapic_next_deadline to kvm_lapic_next_deadline.

The 4th patch, KVM: x86: do lazy_tscdeadline init and exit
Do some init and exit jobs of lazy_tscdeadline. It pins the page at which the gpa
of kvm_lazy_tscdeadline locates and maps it to kernel space. The exit path will
release them.

The 5th patch, KVM: X86: add lazy tscdeadline support to reduce vm-exit of msr-write
It introduces the update, kick and clear operations to make lazy_tscdeadline
work in host side. Refer to following comment,
 - UPDATE, when the guest update msr of tsc deadline, we need to
   update the value of 'armed' field of kvm_lazy_tscdeadline
 - KICK, when the hv or sw timer is fired, we need to check the
   'pending' field to decide whether to re-arm timer or inject
   local timer vector. The sw timer is not in vcpu context, so a
   new kvm req is added to handle the kick in vcpu context.
 - CLEAR, this is a bit tricky. We need to clear the 'armed' field
   properly otherwise the guestOS can be hung.

The 6th patch, KVM: x86: add debugfs file for lazy tscdeadline per vcpu
Add a debug entry for this feature.


Changes from V2:
 - Comments and chart in cover letter and patches are rewritten
 - Move weak_wrmsr_fence after updating @pending the avoid re-order of update
   @pending and read @armed
 - Split the orignial 3rd patch into 3 to reduce the size of patches
 - Avoid to inject interrupt into guest when lazy tscdeadline timer is kicked
 - Add kvm_vcpu_kick() when write to lazy_tscdeadline debugfs interface

Changes from V1:
 - In 3rd patch, rename the variable of kvm_host_lazy_tscdeadline from 'host'
   to 'hlt'. And in addition, add more details into the comment of patch
 - Add 4th patch which add debugfs file for this patch

Any comment is welcome.

Thanks
Jianchao

Wang Jianchao (6)
	KVM: x86: add debugfs file for lazy tscdeadline per vcpu
	KVM: X86: add lazy tscdeadline support to reduce vm-exit of msr-write
	KVM: x86: do lazy_tscdeadline init and exit
	x86/apic: switch set_next_event to lazy tscdeadline version
	KVM: x86: exchange info about lazy_tscdeadline with msr
	KVM: x86: add msr register and data structure for lazy tscdeadline


 arch/x86/include/asm/kvm_host.h |  10 ++++++++
 arch/x86/kernel/apic/apic.c     |  30 +++++++++++++++++++++-
 arch/x86/kernel/kvm.c           |  13 ++++++++++
 arch/x86/kvm/debugfs.c          |  80 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/lapic.c            | 138 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 arch/x86/kvm/lapic.h            |   4 +++
 arch/x86/kvm/x86.c              |  27 ++++++++++++++++++++
 7 files changed, 291 insertions(+), 11 deletions(-)
