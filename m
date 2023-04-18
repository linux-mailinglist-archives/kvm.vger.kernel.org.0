Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA7B6E6893
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 17:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbjDRPtL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 11:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbjDRPtJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 11:49:09 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC317EFA;
        Tue, 18 Apr 2023 08:49:07 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id o6-20020a05600c4fc600b003ef6e6754c5so56371wmq.5;
        Tue, 18 Apr 2023 08:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681832945; x=1684424945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zNGggXBj/YjGZ6A1qh5gK0cjgPin4WDFdJ7XH94R/L0=;
        b=OiQvNtaqgJRCAYJ8jvAV8Xh4/ZhOEeIv/7kqlcQP7y77S10eRaMu/KoKTTn10guuJx
         +g9qM3hN+0NgWuLJJ2gFxsXY0TzW/PmfC8yv55989lJVOFi1c9Ss8OguqvqnEZrWL3Lo
         nhP8qL16xIQKQK7tChr0XkG3WJ/Ls3sJK1RDELyqSOuMYP7WgNHJI+/TgUfi+vgT9QNm
         B4IzhlNPq8bcnHxV0WZTnO22pTjwgEarf6cgrYriGpwClEEM11Zepaxamd43fYa7opWd
         gq5ASY0R6rj9Dc6bwpOO4hUJ7lTQSuwSu6fENmYXJ9glcRpzzYFs/2VjTUCah8x/baBI
         XbEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681832945; x=1684424945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zNGggXBj/YjGZ6A1qh5gK0cjgPin4WDFdJ7XH94R/L0=;
        b=Y9qc2XfwnU+wVkjA1syPNMuyrHe0x9wHKegFPubZgMdgmGc9nERd/xOjwfamBou1tF
         o2M2AHQCowNvR4f5Gf+cGxGWOuaE8z3R9SOaBPnNMjaskmqpMVRBaWPDG76pIJjAIqX+
         BOLXg3xldLecTGu/xrGQ+LQC0fbeQMXB8iHAKYk2NeJG4tHBEaIdi02kXeFLMxJXBki5
         ljLx5smQe44pnVkb6hHYJC0v3f2Iu7GyZqWp0Yj4t4wkyzWmckhfMtUb5ZqLsNPzzzI/
         kWrBNCsDo6T86m6fMwVL6KAWoy/RrJrrSleyfXAlm+sLot3QNRrWXxBTgHcciwn8ZKUQ
         6ayA==
X-Gm-Message-State: AAQBX9c2CTc+6bpL6DK03tXjonPYNsSDY8o2lHBYhD1dq/kXkdLBSr3K
        rbA5zxRVgKhpIqfHN9I5YOs=
X-Google-Smtp-Source: AKy350aHDRRWyxYtdICupSbabDM0SYNg7JwpwlKjL5bja7KYaQer4ZpvTkwbrAwjYCA1wLTr85S01Q==
X-Received: by 2002:a05:600c:22c4:b0:3ed:88f5:160a with SMTP id 4-20020a05600c22c400b003ed88f5160amr14355036wmg.11.1681832945586;
        Tue, 18 Apr 2023 08:49:05 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id 26-20020a05600c021a00b003f17848673fsm2934468wmi.27.2023.04.18.08.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 08:49:04 -0700 (PDT)
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>, Xinhui Pan <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v4 1/6] mm/gup: remove unused vmas parameter from get_user_pages()
Date:   Tue, 18 Apr 2023 16:49:01 +0100
Message-Id: <cd05b41d6d15ee9ff94273bc116ed3db3f5125bf.1681831798.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681831798.git.lstoakes@gmail.com>
References: <cover.1681831798.git.lstoakes@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No invocation of get_user_pages() uses the vmas parameter, so remove
it.

The GUP API is confusing and caveated. Recent changes have done much to
improve that, however there is more we can do. Exporting vmas is a prime
target as the caller has to be extremely careful to preclude their use
after the mmap_lock has expired or otherwise be left with dangling
pointers.

Removing the vmas parameter focuses the GUP functions upon their primary
purpose - pinning (and outputting) pages as well as performing the actions
implied by the input flags.

This is part of a patch series aiming to remove the vmas parameter
altogether.

Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c     | 2 +-
 drivers/gpu/drm/radeon/radeon_ttm.c | 2 +-
 drivers/misc/sgi-gru/grufault.c     | 2 +-
 include/linux/mm.h                  | 3 +--
 mm/gup.c                            | 9 +++------
 mm/gup_test.c                       | 5 ++---
 virt/kvm/kvm_main.c                 | 2 +-
 7 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 21ca0a831b70..5d390df21440 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -214,7 +214,7 @@ static int __sgx_encl_add_page(struct sgx_encl *encl,
 	if (!(vma->vm_flags & VM_MAYEXEC))
 		return -EACCES;
 
-	ret = get_user_pages(src, 1, 0, &src_page, NULL);
+	ret = get_user_pages(src, 1, 0, &src_page);
 	if (ret < 1)
 		return -EFAULT;
 
diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 1e8e287e113c..0597540f0dde 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -362,7 +362,7 @@ static int radeon_ttm_tt_pin_userptr(struct ttm_device *bdev, struct ttm_tt *ttm
 		struct page **pages = ttm->pages + pinned;
 
 		r = get_user_pages(userptr, num_pages, write ? FOLL_WRITE : 0,
-				   pages, NULL);
+				   pages);
 		if (r < 0)
 			goto release_pages;
 
diff --git a/drivers/misc/sgi-gru/grufault.c b/drivers/misc/sgi-gru/grufault.c
index b836936e9747..378cf02a2aa1 100644
--- a/drivers/misc/sgi-gru/grufault.c
+++ b/drivers/misc/sgi-gru/grufault.c
@@ -185,7 +185,7 @@ static int non_atomic_pte_lookup(struct vm_area_struct *vma,
 #else
 	*pageshift = PAGE_SHIFT;
 #endif
-	if (get_user_pages(vaddr, 1, write ? FOLL_WRITE : 0, &page, NULL) <= 0)
+	if (get_user_pages(vaddr, 1, write ? FOLL_WRITE : 0, &page) <= 0)
 		return -EFAULT;
 	*paddr = page_to_phys(page);
 	put_page(page);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 37554b08bb28..b14cc4972d0b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2380,8 +2380,7 @@ long pin_user_pages_remote(struct mm_struct *mm,
 			   unsigned int gup_flags, struct page **pages,
 			   struct vm_area_struct **vmas, int *locked);
 long get_user_pages(unsigned long start, unsigned long nr_pages,
-			    unsigned int gup_flags, struct page **pages,
-			    struct vm_area_struct **vmas);
+		    unsigned int gup_flags, struct page **pages);
 long pin_user_pages(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages,
 		    struct vm_area_struct **vmas);
diff --git a/mm/gup.c b/mm/gup.c
index 1f72a717232b..7e454d6b157e 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2251,8 +2251,6 @@ long get_user_pages_remote(struct mm_struct *mm,
  * @pages:      array that receives pointers to the pages pinned.
  *              Should be at least nr_pages long. Or NULL, if caller
  *              only intends to ensure the pages are faulted in.
- * @vmas:       array of pointers to vmas corresponding to each page.
- *              Or NULL if the caller does not require them.
  *
  * This is the same as get_user_pages_remote(), just with a less-flexible
  * calling convention where we assume that the mm being operated on belongs to
@@ -2260,16 +2258,15 @@ long get_user_pages_remote(struct mm_struct *mm,
  * obviously don't pass FOLL_REMOTE in here.
  */
 long get_user_pages(unsigned long start, unsigned long nr_pages,
-		unsigned int gup_flags, struct page **pages,
-		struct vm_area_struct **vmas)
+		    unsigned int gup_flags, struct page **pages)
 {
 	int locked = 1;
 
-	if (!is_valid_gup_args(pages, vmas, NULL, &gup_flags, FOLL_TOUCH))
+	if (!is_valid_gup_args(pages, NULL, NULL, &gup_flags, FOLL_TOUCH))
 		return -EINVAL;
 
 	return __get_user_pages_locked(current->mm, start, nr_pages, pages,
-				       vmas, &locked, gup_flags);
+				       NULL, &locked, gup_flags);
 }
 EXPORT_SYMBOL(get_user_pages);
 
diff --git a/mm/gup_test.c b/mm/gup_test.c
index 8ae7307a1bb6..9ba8ea23f84e 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -139,8 +139,7 @@ static int __gup_test_ioctl(unsigned int cmd,
 						 pages + i);
 			break;
 		case GUP_BASIC_TEST:
-			nr = get_user_pages(addr, nr, gup->gup_flags, pages + i,
-					    NULL);
+			nr = get_user_pages(addr, nr, gup->gup_flags, pages + i);
 			break;
 		case PIN_FAST_BENCHMARK:
 			nr = pin_user_pages_fast(addr, nr, gup->gup_flags,
@@ -161,7 +160,7 @@ static int __gup_test_ioctl(unsigned int cmd,
 						    pages + i, NULL);
 			else
 				nr = get_user_pages(addr, nr, gup->gup_flags,
-						    pages + i, NULL);
+						    pages + i);
 			break;
 		default:
 			ret = -EINVAL;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d255964ec331..7f31e0a4adb5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2474,7 +2474,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 {
 	int rc, flags = FOLL_HWPOISON | FOLL_WRITE;
 
-	rc = get_user_pages(addr, 1, flags, NULL, NULL);
+	rc = get_user_pages(addr, 1, flags, NULL);
 	return rc == -EHWPOISON;
 }
 
-- 
2.40.0

