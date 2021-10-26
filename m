Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D7E43B5F5
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 17:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbhJZPrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 11:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbhJZPrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 11:47:15 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6F4C061767
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 08:44:52 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id a26so3901400pfr.11
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 08:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8kDQ7IbJvPRtCszhku3mVVwZmsJF6qyXbsNM96p2fn8=;
        b=ZvTGeGXWn24vQJdl92YJ9WlImucFI/8MnATNK6OkhKPLuTzPrPII2emi8Yw2+kIuM5
         vI7/1eyLk45Gaz2VkLlQ6nL5tH5XyRbWpSWhV5grG4olcdA1fudm9b94S/nsj0/4KAuH
         2ls7eeShVOJ5FcSBorjGcVGJDTFH9wgiB+lPd5A5ipdLXAsAOcHQf81jjLoVRUbPWpcb
         pPpu1Gw15EzNRZsWwtZDidEti8UXCArKPFQt7zonm/P1SeWcte4xjlI0vX6jkgsUVK1W
         zTy01CQgiFhf+BtiZh1Cf7T26UelJQ04MEY9ngMdJMEQv1Fw3yd0kbZ4NGC6ikuQmvQ1
         5/pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8kDQ7IbJvPRtCszhku3mVVwZmsJF6qyXbsNM96p2fn8=;
        b=eEtoobS9zHhR79khoB85EV08J+lq2bU+eetj+6ZO7OqPuGBBhu/ZjQeJNpSR4HtBHA
         LDfO3u/gRfCXoo+S2pC5Gk/sBOjjeHn1a9xfpRuVI5RBAh2/osKXeZB4+qYctnufnRsc
         ZQMnYJYds0jDe1YwyVHQRnOxuxCtTSChRexi7FfIk0MgnzNSu0apMBkasvqLmrixf8Cy
         3Lnz/v3YlD6++QCnV/JgXlrM43601AgzCxQV++4iBCAEhUupS27koDJW5wXFYUhPt4KF
         n6mWTibjnt3hAUkpJwSPZf6mZmsVqFh93bUJnCv6zpM+9/T4oxW1zzr6RTTBBKCPBvng
         WGDw==
X-Gm-Message-State: AOAM530jQcJnTw0lLpDV2Es2sBZoiqngfZ1F4TNk3noAqujdj9RvEmMI
        /yWQZBZe88s9LEoAnFvNk1JiBfA/oC67kA==
X-Google-Smtp-Source: ABdhPJzbfnz5tyozuUqvKhHLNVs6nRud0/gjILYz6RtT0CUoC9g5hb1oh1klF+sXTWOO8AU9YUfTXA==
X-Received: by 2002:a63:b002:: with SMTP id h2mr7369830pgf.464.1635263091403;
        Tue, 26 Oct 2021 08:44:51 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j12sm16714952pfu.33.2021.10.26.08.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 08:44:50 -0700 (PDT)
Date:   Tue, 26 Oct 2021 15:44:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Qian Cai <quic_qiancai@quicinc.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: Avoid shadowing a local in search_memslots()
Message-ID: <YXgib3l+sSwy8Sje@google.com>
References: <20211026151310.42728-1-quic_qiancai@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026151310.42728-1-quic_qiancai@quicinc.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 26, 2021, Qian Cai wrote:
> It is less error-prone to use a different variable name from the existing
> one in a wider scope. This is also flagged by GCC (W=2):
> 
> ./include/linux/kvm_host.h: In function 'search_memslots':
> ./include/linux/kvm_host.h:1246:7: warning: declaration of 'slot' shadows a previous local [-Wshadow]
>  1246 |   int slot = start + (end - start) / 2;
>       |       ^~~~
> ./include/linux/kvm_host.h:1240:26: note: shadowed declaration is here
>  1240 |  struct kvm_memory_slot *slot;
>       |                          ^~~~
> 

Even though this doesn't need to go to stable, probably worth adding a Fixes: to
acknowledge that this was a recently introduced mess.

  Fixes: 0f22af940dc8 ("KVM: Move last_used_slot logic out of search_memslots")


> Signed-off-by: Qian Cai <quic_qiancai@quicinc.com>
> ---
>  include/linux/kvm_host.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 60a35d9fe259..1c1a36f658fe 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1243,12 +1243,12 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index)
>  		return NULL;
>  
>  	while (start < end) {
> -		int slot = start + (end - start) / 2;
> +		int new_slot = start + (end - start) / 2;

new_slot isn't a great name, the integer "slot" isn't directly connected to the
final memslot and may not be representative of the final memslot's index depending
on how the binary search resolves.

Maybe "pivot"?  Or just "tmp"?  I also vote to hoist the declaration out of the
loop precisely to avoid potential shadows, and to also associate the variable
with the "start" and "end" variables, e.g.

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 60a35d9fe259..663bdfa0983f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1235,7 +1235,7 @@ try_get_memslot(struct kvm_memslots *slots, int slot_index, gfn_t gfn)
 static inline struct kvm_memory_slot *
 search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index)
 {
-       int start = 0, end = slots->used_slots;
+       int start = 0, end = slots->used_slots, pivot;
        struct kvm_memory_slot *memslots = slots->memslots;
        struct kvm_memory_slot *slot;

@@ -1243,12 +1243,11 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index)
                return NULL;

        while (start < end) {
-               int slot = start + (end - start) / 2;
-
-               if (gfn >= memslots[slot].base_gfn)
-                       end = slot;
+               pivot = start + (end - start) / 2;
+               if (gfn >= memslots[pivot].base_gfn)
+                       end = pivot;
                else
-                       start = slot + 1;
+                       start = pivot + 1;
        }

        slot = try_get_memslot(slots, start, gfn);
