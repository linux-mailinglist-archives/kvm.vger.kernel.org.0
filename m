Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10AD3647AC3
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 01:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiLIA2E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 19:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiLIA2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 19:28:03 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7DB79CB4
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 16:28:02 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id f3so2493667pgc.2
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 16:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eW8K+BNldesCck4OAbowATcCZnmQD+hw+9oKUlYQOq4=;
        b=bkTXzjhfbYiNZ+Ervu84V0OZVxkj1edOwaSMuQTy3OCKDHnHqezISJCZnTAJBTet/N
         jh1QgIjNZ7jVPXHP4cQf1cy4XZ3fvqHRqHLc27cGsbafcKUWYQ++Gia0bm2zev1UEYXg
         6C2MSafq75ay43dmAbNWgl/PWivnVQY0mJ/7vIrb5IjSNn2hPMnI8K1YDRA/D2H2Vv5/
         r5Wo9RaewBy6qkVEeqFWbfaPB1zHxPfGSDHDy0c9nm/wtWFv+wG5R+9Wdiq7cRqDRAAn
         K/Be2lPXIUblVr8+Bf9zCaPqtUU5c/13qrX6kECFzjcoLnwPMyf+3rJjFlgQ83aRpXnJ
         iadw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eW8K+BNldesCck4OAbowATcCZnmQD+hw+9oKUlYQOq4=;
        b=2cOWk3Tya7FhQPIu4tFpZ5iLCMoxG3eL3gwAsWi8wMwkuCFSuQSPI+L25TKHBRcTdw
         dDTm0IiNaH+z6DrDY/BjmKC026e5wSHYbQC12acdeQUym2EG4J3FGOtH6q30QENxPxRQ
         IjNdoQmMPWV/IrV7EynifRulqqi0rZEDxPwbDYr/ZeyP4hDTOki09sTG9UoZ2qisn9hU
         6BMs+4zSvh67vz0uhzWWgP26FYMc5tPtMXDvkcPcuWcKKxikvTDUvDWxJ0ypj7JffRn5
         9G+0V0SbNxjDEF8egujJSrSfNz62aq9wIoWJVb1klif48iWhheryVcGYs3v7aBv3lqHl
         JN4Q==
X-Gm-Message-State: ANoB5pkPS47kx4EXI6hE/OBCyBQDkxKoEcd41qSBoEpIf13wC9AF7fmk
        a++mrAWcx0xrZl3xTZ9EXggHcQ==
X-Google-Smtp-Source: AA0mqf6usXIpS1WG/nimp4pwfrYIrZkGAtpvSk6/Mi2Lfd4FcOUXOednofUmeaL6n6oHgVT7NsmUqA==
X-Received: by 2002:a62:5501:0:b0:566:900e:1031 with SMTP id j1-20020a625501000000b00566900e1031mr3441900pfb.17.1670545681794;
        Thu, 08 Dec 2022 16:28:01 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id p127-20020a62d085000000b00562677968aesm87230pfg.72.2022.12.08.16.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 16:28:01 -0800 (PST)
Date:   Thu, 8 Dec 2022 16:27:57 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     bgardon@google.com, seanjc@google.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v2 2/2] KVM: x86/mmu: Allocate page table pages on NUMA
 node of underlying pages
Message-ID: <Y5KBDXzPFw3PaSVD@google.com>
References: <20221201195718.1409782-1-vipinsh@google.com>
 <20221201195718.1409782-3-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201195718.1409782-3-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 01, 2022 at 11:57:18AM -0800, Vipin Sharma wrote:
> Page table pages of a VM are currently allocated based on the current
> task's NUMA node or its mempolicy. This can cause suboptimal remote
> accesses by the vCPU if it is accessing physical pages local to its NUMA
> node but the page table pages mapping those physcal pages were created
> by some other vCPU which was on different NUMA node or had different
> policy.
> 
> Allocate page table pages on the same NUMA node where underlying
> physical page exists. Page table at level 5, 4, and 3 might not end up
> on the same NUMA node as they can span multiple NUMA nodes.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
...
> @@ -6284,13 +6326,16 @@ static int shadow_mmu_try_split_huge_page(struct kvm *kvm,
>  	gfn = kvm_mmu_page_get_gfn(huge_sp, spte_index(huge_sptep));
>  	level = huge_sp->role.level;
>  	spte = *huge_sptep;
> +	nid = kvm_pfn_to_refcounted_page_nid(spte_to_pfn(spte));
> +	if (nid == NUMA_NO_NODE)
> +		nid = numa_mem_id();

What do you think about renaming kvm_pfn_to_refcounted_page_nid() to
kvm_pfn_to_page_table_nid() and having it return numa_mem_id() instead
of NUMA_NO_NODE (with a comment)? I think that will clean up this patch
quite a bit by getting rid of all the NUMA_NO_NODE checks.
