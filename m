Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9F57626C9
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbjGYWgB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbjGYWfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:35:44 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B7E7EFD;
        Tue, 25 Jul 2023 15:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690324153; x=1721860153;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iJwptdJ8URixm2JO69W9VJ1O2cZgAeG+0OtQdX6s/p8=;
  b=Vwaj8mS79PDAV+fsous3h2Zqw/QIzqKJ1NeuKvkOzsDRtIs+sBxKfVcu
   VX/TdhM0VgIfZFYlf/jDUok3BHubrIqrR9vDDQr9w2JxaNG9xc4TCN5fR
   Eoqt3uls/iiMkwq1Jqi7pTD8WAv2SHPOpopGq+97aSdCJ4uSpfqgyTeXJ
   r1C/7fjCkCVwzXldEwpskLVKOCNU4y+zm7QMHFuCOIhorYQ/o5qx63mM5
   sWg6NS6H7wPn5vN7oHEnnyM5ipHyyoyU2r2B2beETLna2tPsdXtvDIvw+
   M7LB8EhwAlrnLXmNjtYPehXPK7lqG+5y5QMBR3RiKTk6tGVzlrlcqgepg
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="371467094"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="371467094"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:24:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="972855778"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="972855778"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:24:08 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [RFC PATCH v4 00/16] KVM TDX: TDP MMU: large page support
Date:   Tue, 25 Jul 2023 15:23:46 -0700
Message-Id: <cover.1690323516.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

From: Isaku Yamahata <isaku.yamahata@intel.com>

Changes from v3:
- Rebased to v15 TDX KVM v6.5-rc1 base

Changes from v2:
- implemented page merging path
- rebased to TDX KVM v11

Changes from v1:
- implemented page merging path
- rebased to UPM v10
- rebased to TDX KVM v10
- rebased to kvm.git queue + v6.1-rc8

---
This patch series is based on "v15 KVM TDX: basic feature support".  It
implements large page support for TDP MMU by allowing populating of the large
page and splitting it when necessary.

Feedback for options to merge sub-pages into a large page are welcome.

Remaining TODOs
===============
* Make nx recovery thread use TDH.MEM.RANGE.BLOCK instead of zapping EPT entry.
* Record that the entry is blocked by introducing a bit in spte.  On EPT
  violation, check if the entry is blocked or not.  If the EPT violation is
  caused by a blocked Secure-EPT entry, trigger the page merge logic.

Splitting large pages when necessary
====================================
* It already tracking whether GFN is private or shared.  When it's changed,
  update lpage_info to prevent a large page.
* TDX provides page level on Secure EPT violation.  Pass around the page level
  that the lower level functions needs.
* Even if the page is the large page in the host, at the EPT level, only some
  sub-pages are mapped.  In such cases abandon to map large pages and step into
  the sub-page level, unlike the conventional EPT.
* When zapping spte and the spte is for a large page, split and zap it unlike
  the conventional EPT because otherwise the protected page contents will be
  lost.

Merging small pages into a large page if possible
=================================================
On normal EPT violation, check whether pages can be merged into a large page
after mapping it.

TDX operation
=============
The following describes what TDX operations procedures.

* EPT violation trick
Such track (zapping the EPT entry to trigger EPT violation) doesn't work for
TDX.  For TDX, it will lose the contents of the protected page to zap a page
because the protected guest page is un-associated from the guest TD.  Instead,
TDX provides a different way to trigger EPT violation without losing the page
contents so that VMM can detect guest TD activity by blocking/unblocking
Secure-EPT entry.  TDH.MEM.RANGE.BLOCK and TDH.MEM.RANGE.UNBLOCK.  They
correspond to clearing/setting a present bit in an EPT entry with page contents
still kept.  By TDH.MEM.RANGE.BLOCK and TLB shoot down, VMM can cause guest TD
to trigger EPT violation.  After that, VMM can unblock it by
TDH.MEM.RANGE.UNBLOCK and resume guest TD execution.  The procedure is as
follows.

  - Block Secure-EPT entry by TDH.MEM.RANGE.BLOCK.
  - TLB shoot down.
  - Wait for guest TD to trigger EPT violation.
  - Unblock Secure-EPT entry by TDH.MEM.RANGE.UNBLOCK to resume the guest TD.

* merging sub-pages into a large page
The following steps are needed.
- Ensure that all sub-pages are mapped.
- TLB shoot down.
- Merge sub-pages into a large page (TDH.MEM.PAGE.PROMOTE).
  This requires all sub-pages are mapped.
- Cache flush Secure EPT page used to map subpages.

Thanks,

Isaku Yamahata (4):
  KVM: x86/tdp_mmu: Allocate private page table for large page split
  KVM: x86/tdp_mmu: Try to merge pages into a large page
  KVM: x86/tdp_mmu: TDX: Implement merge pages into a large page
  KVM: x86/mmu: Make kvm fault handler aware of large page of private
    memslot

Xiaoyao Li (12):
  KVM: TDP_MMU: Go to next level if smaller private mapping exists
  KVM: TDX: Pass page level to cache flush before TDX SEAMCALL
  KVM: TDX: Pass KVM page level to tdh_mem_page_add() and
    tdh_mem_page_aug()
  KVM: TDX: Pass size to tdx_measure_page()
  KVM: TDX: Pass size to reclaim_page()
  KVM: TDX: Update tdx_sept_{set,drop}_private_spte() to support large
    page
  KVM: MMU: Introduce level info in PFERR code
  KVM: TDX: Pin pages via get_page() right before ADD/AUG'ed to TDs
  KVM: TDX: Pass desired page level in err code for page fault handler
  KVM: x86/tdp_mmu: Split the large page when zap leaf
  KVM: x86/tdp_mmu, TDX: Split a large page when 4KB page within it
    converted to shared
  KVM: TDX: Allow 2MB large page for TD GUEST

 arch/x86/include/asm/kvm-x86-ops.h |   3 +
 arch/x86/include/asm/kvm_host.h    |  11 ++
 arch/x86/kvm/Kconfig               |   1 +
 arch/x86/kvm/mmu/mmu.c             |  40 +++--
 arch/x86/kvm/mmu/mmu_internal.h    |  35 +++-
 arch/x86/kvm/mmu/tdp_iter.c        |  37 +++-
 arch/x86/kvm/mmu/tdp_iter.h        |   2 +
 arch/x86/kvm/mmu/tdp_mmu.c         | 279 ++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/common.h          |   6 +-
 arch/x86/kvm/vmx/tdx.c             | 227 +++++++++++++++++------
 arch/x86/kvm/vmx/tdx_arch.h        |  21 +++
 arch/x86/kvm/vmx/tdx_errno.h       |   2 +
 arch/x86/kvm/vmx/tdx_ops.h         |  50 ++++--
 arch/x86/kvm/vmx/vmx.c             |   2 +-
 14 files changed, 601 insertions(+), 115 deletions(-)


base-commit: bfa3037d828050896ae52f6467b6ca2489ae6fb1
prerequisite-patch-id: 3bd3037b3803e2d84f0ef98bb6c678be44eddd08
prerequisite-patch-id: b474cbf4f0ea21cf945036271f5286017e0efc84
prerequisite-patch-id: bd96a89fafe51956a55fdfc08a3ea2a37a2e55e4
prerequisite-patch-id: f15d178f9000430e0089c546756ab1d8d29341a7
prerequisite-patch-id: 5b34829d7433fa81ed574d724ee476b9cc2e6a50
prerequisite-patch-id: bf75388851ee37a83b37bfa7cb0084f27301f6bc
prerequisite-patch-id: 9d77fb0e8ce8c8c21e22ff3f26bd168eb5446df0
prerequisite-patch-id: 7152514149d4b4525a0057e3460ff78861e162f5
prerequisite-patch-id: a1d688257a210564ebeb23b1eef4b9ad1f5d7be3
prerequisite-patch-id: 0b1e771c370a03e1588ed97ee77cb0493d9304f4
prerequisite-patch-id: 313219882d617e4d4cb226760d1f071f52b3f882
prerequisite-patch-id: a8ebe373e3913fd0e0a55c57f55690f432975ec0
prerequisite-patch-id: 8b06f2333214e355b145113e33c65ade85d7eac4
prerequisite-patch-id: e739dd58995d35b0f888d02a6bf4ea144476f264
prerequisite-patch-id: 0e93d19cb59f3a052a377a56ff0a4399046818aa
prerequisite-patch-id: 4e0839abbfb8885154e278b4b0071a760199ad46
prerequisite-patch-id: be193bb3393ad8a16ea376a530df20a145145259
prerequisite-patch-id: 301dbdf8448175ea609664c890a3694750ecf740
prerequisite-patch-id: ba8e6068bcef7865bb5523065e19edd49fbc02de
prerequisite-patch-id: 81b25d13169b3617c12992dce85613a2730b0e1b
prerequisite-patch-id: b4526dee5b5a95da0a13116ae0c73d4e69efa3c6
prerequisite-patch-id: 8c62bacc52a75d4a9038a3f597fe436c50e07de3
prerequisite-patch-id: 5618d2414a1ef641b4c247b5e28076f67a765b24
prerequisite-patch-id: 022b4620f6ff729eca842192259e986d126e7fa6
prerequisite-patch-id: 73ebc581a3ce9a51167785d273fe69406ccccaed
prerequisite-patch-id: 1225df90aeae430a74354bc5ad0ddf508d0707db
prerequisite-patch-id: 1e38df398ee370ad7e457f4890d6e4457e8a83fa
prerequisite-patch-id: b8812b613f5674351565ea28354e91a756efd56e
prerequisite-patch-id: e231eff2baba07c2de984dd6cf83ad1a31b792b8
prerequisite-patch-id: 4c3e874f5a81d8faa87f1552c4f66c335e51b10b
prerequisite-patch-id: fa77e23cb08f647a81c8a2d6e15b71d0d9d73d3f
prerequisite-patch-id: 358d933f6d6fafba8fcf363673e4aeaa3175bffa
prerequisite-patch-id: 4b529f51e850c2ae205ccebf06c506a2ceda2352
prerequisite-patch-id: e611ed11739866ed5863c10893447d18f7362793
prerequisite-patch-id: 8d3716956281a5bd4024343c7a6538c635bc4512
prerequisite-patch-id: 5c1099652396c3020b2af559ed2a12cf2725f2fe
prerequisite-patch-id: 554e6bd542b845c1a556f7da4db9c7ac33fe396e
prerequisite-patch-id: 38461b84a4c6292b81a97424f9834f693065c794
prerequisite-patch-id: 5d05b55188360da9737f9cf52a7b888b1393e03f
prerequisite-patch-id: c4b6a6cb6ecd44b4ccb4fd0bd29d3df14ad2df2d
prerequisite-patch-id: 3c93e412ef811eb92d0c9e7442108e57f4c0161d
prerequisite-patch-id: 144982ee3761b30264328bf97f75ad8511c92ef1
prerequisite-patch-id: 2e1bfaa6f636431c64be30567b6ab29612ab667b
prerequisite-patch-id: dbbafc93f22c632974ac4f0f7723dff031f58b44
prerequisite-patch-id: 23844e3aeb137c15225bd1e00e36ff3e28ecf3a4
prerequisite-patch-id: 1df0c588530996d9ed78592aef25a1c28290511d
prerequisite-patch-id: 676e4f00026f36d11a56a09306800f9bbdfdf418
prerequisite-patch-id: c1f6a4380640607966d2574d828e20444fdec82c
prerequisite-patch-id: 2d7d9e53916d8ae7098b81d16c37f8fa36d49ac0
prerequisite-patch-id: 4df02112a774adec078d579304355e665e812c97
prerequisite-patch-id: bf078bcc88a3fa417dcaa3ff284fd9b13dc3c88b
prerequisite-patch-id: 93919b210b5255c8225ba651b64f5a251674dacb
prerequisite-patch-id: 3986d23cd0b46ed5a836d91ff0578b4afd190e39
prerequisite-patch-id: 46449476658cfd8715ff04822508694f64f0e047
prerequisite-patch-id: c0d872fbfe9cf24cb69f93e4d84f39a1fc9cec2d
prerequisite-patch-id: d10a2f5ee80095ddd8ada0a5f524bbc50c2782a9
prerequisite-patch-id: 9612e4f0609b6680bf40c94cbf41f7898b7149b0
prerequisite-patch-id: aa6ebca29f326ee57123b49992584ac1e71cd0c1
prerequisite-patch-id: ebab5bff65b7583b9257849e93b67f71c964630b
prerequisite-patch-id: b0bf2eaba4e53f01e6316780b80cb1e29ac74ee0
prerequisite-patch-id: f4e97d679570433a549ec7c7a9ff87df57adc41c
prerequisite-patch-id: 13625ac5fc2522e74b1c1639ac511206b43256c7
prerequisite-patch-id: be4911c0d255be1706205f3b825630e14dec3398
prerequisite-patch-id: d95adb5a77af86847f0e20fd99f081db3d880827
prerequisite-patch-id: 4dd00540050377ff852c0a939682d5894513444c
prerequisite-patch-id: e21ebef42f8bd94ab61b74eb3d5fe633843e4c8d
prerequisite-patch-id: 2478168dda83b9aef49a4d9131107308f512e9df
prerequisite-patch-id: 6ea8a145d7db1e3287a1d26b63876b6d6b4ea2b5
prerequisite-patch-id: 241e8fd9a85fa5be259cd24b89d94e1555a825b3
prerequisite-patch-id: 1d447fc520ee61b7d136cbfede32a6343ecd8526
prerequisite-patch-id: 5f00989dd01aab4d7f49520347e7427506c40685
prerequisite-patch-id: 3759b94086e48ee7e4853c85af9ea0949b0b18c8
prerequisite-patch-id: 85c853ced4c8d23497b2ff5a31808da64c09798b
prerequisite-patch-id: 3d9be44c3c51aacf9038b143d55acade6e9de323
prerequisite-patch-id: c0f5a5252a1fdbae95b38e4fab27630cb812911e
prerequisite-patch-id: bfabdd06ab51e3eebed14762bb6bc3821bc17f9a
prerequisite-patch-id: 70d7f5c228a85077fa1f31c92e2857cec5687247
prerequisite-patch-id: ff4f6fbd4f9f14ed19e802bebad71f63a1aeb1b9
prerequisite-patch-id: 1f31c884a75ce61edadd32933e9c3f6b5a63c4af
prerequisite-patch-id: 10bdbd913c6b5ad27adabbdc21bb7b4c061b76be
prerequisite-patch-id: 5264da83b82ea2063556180f1789908e7d7bfe20
prerequisite-patch-id: 73063491abd192b08ea6f15d8fad2235646fb01e
prerequisite-patch-id: f80283dc2b5127bb5ab84863ac361269598a96d0
prerequisite-patch-id: 7fc7eea3ca9110f14ca7d07573df087de66ea567
prerequisite-patch-id: ca6b6209f762701a28d03f97a9d849b7194bd8f9
prerequisite-patch-id: 1f3dfb4bd31957ec8845205bb978a42ba38f23d5
prerequisite-patch-id: f8fd0c8378f1dfecc6d1f19735a7387e1a321feb
prerequisite-patch-id: 62fb4481c6d53b0cd695964c7aea05ab5672073f
prerequisite-patch-id: 530de5c34ee8c595960e370a5a55096d014c7cce
prerequisite-patch-id: c6b3e3ed6b86d3309fcd14b59ba5a946ba7038ad
prerequisite-patch-id: 09213e6b300e1390e5b97eec4e75d51242af5e06
prerequisite-patch-id: 367ec96f0c582eab2a6919dc7092cc543620b7ea
prerequisite-patch-id: 2d8eb76da2d77cf4d87b83cf5a4dff319aa8ac97
prerequisite-patch-id: 28e65c507a95947415faa47990764882736c67d7
prerequisite-patch-id: 57d920b1c15a2567736ce1ff5f1214f6d07ab32d
prerequisite-patch-id: 6e05c9b91082ac21b0149152f581b54fd4c0005f
prerequisite-patch-id: f4d423ed7166ae9e05d0eab7f1389c1f028c0593
prerequisite-patch-id: 77814640692b8e3eddcc239c0398388fe0aa10e7
prerequisite-patch-id: 9d6b4a62ebcddfb7f1fb702f9c0194e7e7ba87aa
prerequisite-patch-id: de149d85ce42652e66df50669584efb9cbe6d72b
prerequisite-patch-id: fa40e1fcec3342b520c8ebb2f6ed6a6ffe2f759b
prerequisite-patch-id: f06db517c56a36cac49beff9ff52b69199f33a13
prerequisite-patch-id: 9d644a738f3495192c808647bab0109cad18057a
prerequisite-patch-id: 94617faf0d666a146549c9d8e9936d61a1c8ba15
prerequisite-patch-id: bb093494e96b0c9797745fd430f4e1e1f570bf0b
prerequisite-patch-id: 37154e5673b94164fc805c9e2d1ba0b0669eeb74
prerequisite-patch-id: a509a202c02795fd8439a9feeefa1d118372a73f
prerequisite-patch-id: 1839ee0ce1af0fcc7eed4645c53b54310829890d
prerequisite-patch-id: 83efa503b3cd5b6ddae29e4a7e7144e29b82bfa1
prerequisite-patch-id: 56c1760c611de7fac797b3ebf260a1cc33ced72b
prerequisite-patch-id: d6bf265d34ca38d5b8d7c6344972e68e77ec3fcb
prerequisite-patch-id: 693bd8abe58facc5c1f4d6a2f0a2ad4d5ea86624
prerequisite-patch-id: 677d0e9b5f60aff0e474fa4b4079eb04ac78f244
prerequisite-patch-id: 34cd31ba63d23b556193abbbab3978e967a6b846
prerequisite-patch-id: 712b77a9c15e351a3d8815e699025e6deff71909
prerequisite-patch-id: 1e1fa8306edd877ce406fc1cf5b082b4717950cd
prerequisite-patch-id: d0e48a96c3d2a81b7f7298cbe46b96166fab16a5
prerequisite-patch-id: 4967cee4416a7680e536d93a27ccbcd75c3cdc2a
prerequisite-patch-id: f65606364c47459f0e60f84764203b25cef3897e
prerequisite-patch-id: 6301eb6d3877015632c6bd2fb4d4d11c9504ef30
prerequisite-patch-id: 86a5cd1f1a740f5a331fdefe6c1565ab5042624f
prerequisite-patch-id: c73eec4d8640da745c1bedf9be0557e469c39f86
prerequisite-patch-id: 8193b68fa56b6a3915aa31526c5129322985571e
prerequisite-patch-id: 859dd8422af62bd19d80016f320afb015ac7bc7d
prerequisite-patch-id: 7d633c1131be2afdd191691bd6c76a760651364f
prerequisite-patch-id: a377fa7042b735378a792e28f27b1cc43e11e722
prerequisite-patch-id: a9a34487c048d6c62bd48e2101756525fc58805f
prerequisite-patch-id: c43bb7a0638d6b08585c35896d4962ce19402aa9
prerequisite-patch-id: 023bc742cee689f6db55e0083dde2c44f3edbc77
prerequisite-patch-id: 56fab84ef1691ac9b9629c8ee7571479cbe981ea
prerequisite-patch-id: eb0163d5e486161b8e22991ce3087932794a4bcc
prerequisite-patch-id: 316db61898881a8fcd0b57aab6533e74422e2aca
prerequisite-patch-id: 0d55fc17e3d799c548f8579b01aec271ac579f1d
prerequisite-patch-id: 71d4e5a705089a386f42c6812093d55d0d9f44ec
prerequisite-patch-id: 0bbe899852935ed5b97eb40758706fd1e774e79b
prerequisite-patch-id: 830d049555ccbf661dac2bfe0825de2e6fffc19b
prerequisite-patch-id: 6e1403460c80e7d94f2e0401d878886228213d0a
prerequisite-patch-id: f01d987576425d116d39c3dc0a195fd814ed864a
prerequisite-patch-id: 497371f3094c51a7f2242581930b28d319a6dd93
prerequisite-patch-id: 0555a722fe13d69665526d85ec1dff477d57e572
prerequisite-patch-id: 62d2965e2392d7ab81e38fc5a43161a0238ec1d6
prerequisite-patch-id: fbdabf6fe4f5836f4e0015bd4809c4cf8defeae5
prerequisite-patch-id: d49c285afa37417a1eda4983c80cffecbebcb226
prerequisite-patch-id: 713afe4090cc6a5d03e0505798299e8fe10c67a8
prerequisite-patch-id: f4605a97b041af597616cc4e334b1ce2c96fda89
prerequisite-patch-id: 0220f1418bed8aacc8cf01793e0b4fbc658d9834
prerequisite-patch-id: 50f0f5ec56a8d625f2bbd2a1d9aed6dd19eb9e23
prerequisite-patch-id: f155615a1520b421844626f829bfeb6460838ee7
prerequisite-patch-id: 22d072c6b3af7d055b85108512214877e4792a9c
prerequisite-patch-id: c7c625c835a1590c2f695191f40efd753d415e06
prerequisite-patch-id: c202c186c8cf1813f495a28bc9d0dbeb11a8f26a
prerequisite-patch-id: 117ca93acf7e39b5801fec569c9abe6adbb7e500
prerequisite-patch-id: 852a1c72b7a52fbfd0bb14b56755a4fbf79a6ec1
prerequisite-patch-id: 8f3b3f7f3449f1da247ea89e2027e88065ba2a94
prerequisite-patch-id: 738de5d8a181e3c4763b69c09b70bb88e1e93f85
prerequisite-patch-id: fe791ffefa55b6c271c0cc3a1a658a3c5e3eda03
prerequisite-patch-id: abf39bd923baf524b1071ad00578ccd3471f3318
prerequisite-patch-id: d7a5b549d80f33d8d4a00673c827cffcbbba7d02
prerequisite-patch-id: 31f1343d72fec48432f71b23987d5ac482d4d0e3
prerequisite-patch-id: 561815c250fd5407f45f791fdb63d10b9b5293dc
prerequisite-patch-id: f37372210572bda07b63dce1dddf73922e7c0cb1
prerequisite-patch-id: 840f8215c2ae5264fc3038ff2c7ed83fe6c35fe1
prerequisite-patch-id: bea612f77b1faac60f2a581ef10f33a3312e8435
prerequisite-patch-id: 604c6430b0d02b780c1c8abf158ef99b8911c4ad
prerequisite-patch-id: cf30ebef3b11b8d6654e891f69bf3a1e81050c2a
prerequisite-patch-id: c7a8f9838ccc2d9c8301002ac2d0c5808e089acd
prerequisite-patch-id: 14b93caad07ac2c1098336d4a5fd5e0c7d208011
prerequisite-patch-id: 9f8ebe703f436be49f00ebf0ab13ee7329215923
prerequisite-patch-id: 6109b6886b4fb6c0241548b5639e48ff69f306c7
prerequisite-patch-id: 1318b00e6c377677044a1bb51ad0fe46ac2e2e3c
prerequisite-patch-id: e06f12602791f56bd0204097189151d19de05816
prerequisite-patch-id: 4e4ea15874d5788aea716da17202242355d70b60
prerequisite-patch-id: f5f508eb2ddef431ea6e2141c3a8092355e988b3
prerequisite-patch-id: 0f1d953414afda95278954d9cded2fdd64ed9089
prerequisite-patch-id: 45472dffa449747d7eb3513b365c78f44123732d
prerequisite-patch-id: e7e98c1056fc94ba4387a7ef0b49412958ffd68f
prerequisite-patch-id: 5b2530fd85758847f420540a5ffa8a0cd4e32eda
prerequisite-patch-id: ab980f9533bc7668f3a820103d9c0ec6866ea805
prerequisite-patch-id: e57e3302ce47641cd78db9705815dbf20169746a
prerequisite-patch-id: 6dae9a9de4ebaf8727f0f7f543d882735b180cc3
prerequisite-patch-id: c438562a90dd917471892d82f5257c71c1fbbb37
prerequisite-patch-id: e9ceb3031dec327501e012ca3b53fadfea8676b5
-- 
2.25.1

