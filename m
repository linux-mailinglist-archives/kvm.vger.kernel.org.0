Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6C9C6FFDDD
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 02:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239562AbjELAV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 20:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjELAVz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 20:21:55 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B6B1FE9;
        Thu, 11 May 2023 17:21:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ob37/gqr2JcxmeiVleZfVCgXm46twT9tfgtuYz+SVL+3gec6Ok0a5EuQ6NKWNYsC3yXQd8pZIEFNOfcL2DHP5FfCYbCg1PLsqFoJUOh+RhRz/vdNAOC5NxH9T4i586jDby6j6H9yWWjQg0ItkZ+F07h5Swx/XGewfQXfSfphlZtEoxvhhgEpEtcKb2XrGo8VMDmRFgKD9oB8/pEm/Lar1marj+o8+9eHNpAu54ZfvPTWxCsOX/sk9TF/MjZiicwYsxWKzLuc9K5o25BljwMJHl4C7/3JKnu+pkfr8x32nbPsS2IiTab1pcK8db/seUlpXKRxBP84u7QhP/pRwh0SEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EquUkY10O+lzNH9T1N390jVzh2a47wFTZvRHWUJEOcw=;
 b=Dl8SeVCI6FR3nwPeHmsYa3vzulG6WOvUIw16pfC6PO8Rp/7rZTdPgVRCTypBN6l1oY9s1mwNBrXLGg5jWIDCJgC4qHT2jwsF5WpbymceNv7dGKx1TXDSfxasBT8L/jKaE0LZl4Rh/KVgrsQrw2Vjt2irGOhxa0Hi0nZh035J23bySTRDDEw/Gi9loK5y6QzAsuVCvoxdRdsZNS7Lmw3NQlQx/Zc/bHq6dJ6+A/hi1QX992YaRwIiKs6lVOdpRhcYA6uTn2W0xxdaY55RMTtBw0oQ2RVHeuOQreQAJS9M7esKHg5ruGUSc+Ij9+mJWIy3aRmifGFMpx4pKzIRgyiwhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EquUkY10O+lzNH9T1N390jVzh2a47wFTZvRHWUJEOcw=;
 b=RttOJwIL7dpgZQf/Nb2/hC/zTAFERJQH+c6tAeERATp3V/u3RhPuNchUVwHFXZ5g8OOU07jyw+18v+pc6e0P/JdFBGX3ImIawM/Dn0I2H5S134Fjl+kbTt4EZ5qRzmla2/r0+tCbBSL7ynuUgvYPETzEc2YFCwEj4D+i3CAEOXs=
Received: from BN0PR04CA0003.namprd04.prod.outlook.com (2603:10b6:408:ee::8)
 by PH7PR12MB6738.namprd12.prod.outlook.com (2603:10b6:510:1a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Fri, 12 May
 2023 00:21:51 +0000
Received: from BN8NAM11FT101.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::b5) by BN0PR04CA0003.outlook.office365.com
 (2603:10b6:408:ee::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22 via Frontend
 Transport; Fri, 12 May 2023 00:21:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT101.mail.protection.outlook.com (10.13.177.126) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6387.23 via Frontend Transport; Fri, 12 May 2023 00:21:50 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 11 May
 2023 19:21:49 -0500
Date:   Thu, 11 May 2023 19:21:24 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     David Hildenbrand <david@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        <dhildenb@redhat.com>, Quentin Perret <qperret@google.com>,
        <tabba@google.com>, <wei.w.wang@intel.com>,
        Mike Rapoport <rppt@kernel.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ackerley Tng <ackerleytng@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Christian Brauner <brauner@kernel.org>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
Message-ID: <20230512002124.3sap3kzxpegwj3n2@amd.com>
References: <20221202061347.1070246-1-chao.p.peng@linux.intel.com>
 <ZD1oevE8iHsi66T2@google.com>
 <658018f9-581c-7786-795a-85227c712be0@redhat.com>
 <ZD12htq6dWg0tg2e@google.com>
 <1ed06a62-05a1-ebe6-7ac4-5b35ba272d13@redhat.com>
 <ZD2bBB00eKP6F8kz@google.com>
 <9efef45f-e9f4-18d1-0120-f0fc0961761c@redhat.com>
 <ZD86E23gyzF6Q7AF@google.com>
 <5869f50f-0858-ab0c-9049-4345abcf5641@redhat.com>
 <ZEM5Zq8oo+xnApW9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZEM5Zq8oo+xnApW9@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT101:EE_|PH7PR12MB6738:EE_
X-MS-Office365-Filtering-Correlation-Id: cef64e25-2035-4f12-7d8d-08db527ee18b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MRCveg4b1UrmSap3yvGFgnuAp8ceZWOCDkp1/vhwnv5l3IH1alu2LJtB1mB3AmqPGH1p5EqJvnTjv9PFLPgTgZPeE7K3ptBvYFuVkmaLck/zIm5pb1f0Kn1iWbYR5uPshvCWhCjfscGci3dGXjMmDElMM7F07ceznUnB/AprG1xU3l/dx2NsLoWYG1u5GzJ4XyosS4k+goDRxZKDPRwf4lnmc8qlBioBZvlYe+p+EKK8akK/laeFdZRrAeLA+uR1s4rmWdqwJbjvtR7LgIvJpCmt+vtkbFUtjoh5jX1XoJxbqQ6sEX8AlutEQA5veqXh0TivaBGkTPrIwdK7ChXJvcNkCeg9Ic7Ek8ClDwKwtgiJVKCYydcUFIRgacYpzDpEgAqh2WvoPSZVtKSJKJrENE1lRuHcxJyPDt/2iViWAamVw0vTcLjN1RYGDD/vheKxWelOKQBDcuEB8TZFjETCJOy8Yu6vTFOIt4u1jEhRaIY2XQ+zs4QhgK1MblJMAW2kfJA+VN9oNU4NJgpgAimV67FRmJyyzjFRtVsiCQig3wf88dJFJvCv4YMIYpq0O/7z7wIbB47OufK4zDB5XG0/FHf/mzkMD56N2fqf08BSHqnjasaD2OqNxU/ISJtEh5GyxBqtdeJnCHJ/pYLwBU7oKc0ythc9aorfod5T6pJx7ngn4+K8d9wIxLjQI6OZ1yE+moGd8KGq0whP5h6348dFye/RzW7xjmTo/fb/fsTBdwRHHeZzC+yFC6kBWo4AqAv+jK6SRbvnWH1NriXr9kedqA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199021)(46966006)(40470700004)(36840700001)(186003)(54906003)(70586007)(478600001)(86362001)(82310400005)(966005)(70206006)(41300700001)(6666004)(316002)(5660300002)(36756003)(8936002)(8676002)(6916009)(4326008)(356005)(44832011)(82740400003)(7416002)(81166007)(40460700003)(83380400001)(26005)(1076003)(16526019)(36860700001)(2906002)(47076005)(336012)(426003)(2616005)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 00:21:50.6116
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cef64e25-2035-4f12-7d8d-08db527ee18b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT101.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6738
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 06:33:26PM -0700, Sean Christopherson wrote:
> 
> Code is available here if folks want to take a look before any kind of formal
> posting:
> 
> 	https://github.com/sean-jc/linux.git x86/kvm_gmem_solo

Hi Sean,

I've been working on getting the SNP patches ported to this but I'm having
some trouble working out a reasonable scheme for how to work the
RMPUPDATE hooks into the proposed design.

One of the main things is kvm_gmem_punch_hole(): this is can free pages
back to the host whenever userspace feels like it. Pages that are still
marked private in the RMP table will blow up the host if they aren't returned
to the normal state before handing them back to the kernel. So I'm trying to
add a hook, orchestrated by kvm_arch_gmem_invalidate(), to handle that,
e.g.:

  static long kvm_gmem_punch_hole(struct file *file, int mode, loff_t offset,
                                  loff_t len)
  {
          struct kvm_gmem *gmem = file->private_data;
          pgoff_t start = offset >> PAGE_SHIFT;
          pgoff_t end = (offset + len) >> PAGE_SHIFT;
          struct kvm *kvm = gmem->kvm;
  
          /*
           * Bindings must stable across invalidation to ensure the start+end
           * are balanced.
           */
          filemap_invalidate_lock(file->f_mapping);
          kvm_gmem_invalidate_begin(kvm, gmem, start, end);
  
          /* Handle arch-specific cleanups before releasing pages */
          kvm_arch_gmem_invalidate(kvm, gmem, start, end);
          truncate_inode_pages_range(file->f_mapping, offset, offset + len);
  
          kvm_gmem_invalidate_end(kvm, gmem, start, end);
          filemap_invalidate_unlock(file->f_mapping);
  
          return 0;
  }

But there's another hook, kvm_arch_gmem_set_mem_attributes(), needed to put
the page in its intended state in the RMP table prior to mapping it into the
guest's NPT. Currently I'm calling that hook via
kvm_vm_ioctl_set_mem_attributes(), just after kvm->mem_attr_array is updated
based on the ioctl. The reasoning there is that KVM MMU can then rely on the
existing mmu_invalidate_seq logic to ensure both the state in the
mem_attr_array and the RMP table are in sync and up-to-date once MMU lock is
acquired and MMU is ready to map it, or retry #NPF otherwise.

But for kvm_gmem_punch_hole(), kvm_vm_ioctl_set_mem_attributes() can potentially
result in something like the following sequence if I implement things as above:

  CPU0: kvm_gmem_punch_hole():
          kvm_gmem_invalidate_begin()
          kvm_arch_gmem_invalidate()         // set pages to default/shared state in RMP table before free'ing
  CPU1: kvm_vm_ioctl_set_mem_attributes():
          kvm_arch_gmem_set_mem_attributes() // maliciously set pages to private in RMP table
  CPU0:   truncate_inode_pages_range()       // HOST BLOWS UP TOUCHING PRIVATE PAGES
          kvm_arch_gmem_invalidate_end()

One quick and lazy solution is to rely on the fact that
kvm_vm_ioctl_set_mem_attributes() holds the kvm->slots_lock throughout the
entire begin()/end() portion of the invalidation sequence, and to similarly
hold the kvm->slots_lock throughout the begin()/end() sequence in
kvm_gmem_punch_hole() to prevent any interleaving.

But I'd imagine overloading kvm->slots_lock is not the proper approach. But
would introducing a similar mutex to keep these operations grouped/atomic be
a reasonable approach to you, or should we be doing something else entirely
here?

Keep in mind that RMP updates can't be done while holding KVM->mmu_lock
spinlock, because we also need to unmap pages from the directmap, which can
lead to scheduling-while-atomic BUG()s[1], so that's another constraint we
need to work around.

Thanks!

-Mike

[1] https://lore.kernel.org/linux-coco/20221214194056.161492-7-michael.roth@amd.com/T/#m45a1af063aa5ac0b9314d6a7d46eecb1253bba7a

> 
> [1] https://lore.kernel.org/all/ff5c5b97-acdf-9745-ebe5-c6609dd6322e@google.com
> [2] https://lore.kernel.org/all/20230418-anfallen-irdisch-6993a61be10b@brauner
> [3] https://lore.kernel.org/linux-mm/20200522125214.31348-1-kirill.shutemov@linux.intel.com
