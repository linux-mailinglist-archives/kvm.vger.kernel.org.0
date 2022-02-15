Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994184B6D22
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 14:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbiBONOo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 08:14:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235254AbiBONOl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 08:14:41 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F822D007A
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 05:14:31 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id f37so10496152lfv.8
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 05:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6lHSX3nDfvtiD3huNGIKRJsACSoavhTr9PgfPRk1Big=;
        b=ESudXjEoiYV67csMAz6wN1JL4hXkVwKkPOqRxXMFLxHapy+iAL6CtnAp5lJJKxftcc
         tnEuFlvih63DPCMc5rMm8JaRH/xZVy8acSSvr+UGE3IQQ501svmUL3McYgPNYlDWiNzG
         Tse3SmlGCSTcKPHd+PJNQYjoaLFm5XQEVVsiF5Nx2nsQqfOb8TS6CXG0S8KgWk0xkWmH
         57y06dxQr31Od00TkqWsoE4vI7VaGSxiPmcouTy4BngG8hVxMt/dX4O7p0jhEkuEzuA8
         WcRXRASzCPoJrQT99cPLKxNEsyWIcmdY70urf97+R+oah5HuBBpGYFe3aLxkP6kzdziV
         D9oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6lHSX3nDfvtiD3huNGIKRJsACSoavhTr9PgfPRk1Big=;
        b=4l58Hfirc5dNvgBap2cv3pLRAoOQYljrSkrEs4OFn45Paz4L3povfAEPsZ5rfkqLYv
         ffqceNa0FKXIGTlJuyPBTqksF/HC3qhFLRjQ/Xe24j7+WPURRtf6RJhNg6QoUX99hFNX
         uncCSEQp9pHO7dS9sXeyoEbJP+Q6dukP16Jw/jT4BRKaCojW8+lk0niSJJOeBJOh0Pcs
         A8ZGyJrbwcvzco2kVctE17WvW/fzQBgup4yvKC2NVN1V5Kr8Mt6WtCW0a8LOOqSkjdAs
         J17xYXIKbC+9ceGufaHjwuA07+ulooytRbOzh1z9C1d3KC8+D1GOsvmH1KAXZBpaOjZ3
         MvAA==
X-Gm-Message-State: AOAM530+PoWAUva9ZcUlSMM+0kMiKN0hiqLuhzdEbiW6y9wCzXbbirvk
        MRBjPyRuQp8HuTg59nF545v14A==
X-Google-Smtp-Source: ABdhPJwpX7fwVZjUgY2Y9Z1gaYIpMXSKBhynYSWG9vsJYiEN+wWS3V2I3ZjIJAY26pVz/jAP6abjnA==
X-Received: by 2002:a05:6512:6c7:: with SMTP id u7mr3265230lff.128.1644930869890;
        Tue, 15 Feb 2022 05:14:29 -0800 (PST)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id y9sm4517142lfg.219.2022.02.15.05.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 05:14:29 -0800 (PST)
Received: by box.localdomain (Postfix, from userid 1000)
        id DEEEF103F44; Tue, 15 Feb 2022 16:15:22 +0300 (+03)
Date:   Tue, 15 Feb 2022 16:15:22 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andi Kleen <ak@linux.intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        brijesh.ksingh@gmail.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH v10 21/45] x86/mm: Add support to validate memory when
 changing C-bit
Message-ID: <20220215131522.l3xytgmy4ufrgnlb@box.shutemov.name>
References: <20220209181039.1262882-1-brijesh.singh@amd.com>
 <20220209181039.1262882-22-brijesh.singh@amd.com>
 <YgZ427v95xcdOKSC@zn.tnic>
 <0242e383-5406-7504-ff3d-cf2e8dfaf8a3@amd.com>
 <Ygj2Wx6jtNEEmbh9@zn.tnic>
 <20220215124331.i4vgww733fv5owrx@box.shutemov.name>
 <YguimA5Au4t2A4oj@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YguimA5Au4t2A4oj@zn.tnic>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 15, 2022 at 01:54:48PM +0100, Borislav Petkov wrote:
> On Tue, Feb 15, 2022 at 03:43:31PM +0300, Kirill A. Shutemov wrote:
> > I don't think it works. TDX and SME/SEV has opposite polarity of the mask.
> > SME/SEV has to clear the mask to share the page. TDX has to set it.
> > 
> > Making a single global mask only increases confusion.
> 
> Didn't you read the rest of the thread with Tom's suggestion? I think
> there's a merit in having a cc_vendor or so which explicitly states what
> type of HV the kernel runs on...

I have no problem with cc_vendor idea. It looks good.

Regarding the masks, if we want to have common ground here we can add two
mask: cc_enc_mask and cc_dec_mask. And then

pgprotval_t cc_enc(pgprotval_t protval)
{
	protval |= cc_enc_mask;
	protval &= ~cc_dec_mask;
	return protval;
}

pgprotval_t cc_dec(pgprotval_t protval)
{
	protval |= cc_dec_mask;
	protval &= ~cc_enc_mask;
	return protval;
}

It assumes (cc_enc_mask & cc_dec_mask) == 0.

Any opinions?

-- 
 Kirill A. Shutemov
