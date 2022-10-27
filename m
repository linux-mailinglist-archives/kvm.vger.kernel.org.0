Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2675D60FABA
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 16:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235764AbiJ0Opj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 10:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235979AbiJ0OpU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 10:45:20 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D85915DD
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 07:45:03 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso1645113pjc.5
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 07:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UwTsZJHpAarkVCfMmsk/OcucFJNCKaSnInJ8QxuSXZU=;
        b=sK/ZCJilVFiHN1C0llpajbcmWUhuBQurlUT399lNJzCA0S5H5AVjT9UEHO3rZJ6QnD
         XHmXOoBts3sIQ077Efrq2L+3+g2e2zApUrPZMO/CqimWYKvcZ76QrOLwmpHo8UEtV3aP
         4u/64rq6qi3zm/WP4EB2sGC8AAgZ144Bes9/ryGoUrzIL6wvWV2fl5+GiHG1/1Nxxi59
         T222EcV2+nJo/5p20aqajWU1WHXIJ5H2OjYXx/qq3fTcc3rWdLGsSlh7ud0zN5GQqT9K
         3bMw79j+IX73Cwwauwy+3N/n/a2HM3TPVbQ1Rw++8ZJbqNzOn4Vm8j/fEPLiQbhaSsHL
         HACQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UwTsZJHpAarkVCfMmsk/OcucFJNCKaSnInJ8QxuSXZU=;
        b=ZCCpycWodSPlgoKCJ15hHFmrYw+69j9WtXaWu3ulzxDgZGL+p6LXVoDCd06koucF6o
         D5iHZqXhECV2TRxs6b2/hHBuMSGx1Q04wlqXdIt9843sHOp8MmEZyfrqKqVhEGmTfYlr
         A0cy/+c1FXz3U38tv+R17uWB1P1Ic3ER/76JRbQFA6W9L8w+PhaQstbWEA+cOg936nLa
         xRwNAKY6ddetJJ6gKWehSSRzKNd5O4TmnJMauRmhIPHa9wzpNleoFUK2kpvHcWcxmnwc
         CsChdDzm1aP8kFbJA22Ef2kZqDVG1mGng+dI/NQb9H3m9Q2icLnCHeCGFdBmoVOBXl/l
         xoFw==
X-Gm-Message-State: ACrzQf0tgCLdJgPyLC3s9bHSIqJuBYogmduwypfMzopzBXchXIPa4QnP
        dyondX8P8j00mxQ3i+Bz2heu2w==
X-Google-Smtp-Source: AMsMyM7fOuK6peBJcnI1TXb7UvVWM0eTPQ6E2PcmhFOfxFUx13hJ6BhpqTQVGe2EVDMr8wWj+QGbwg==
X-Received: by 2002:a17:902:bc88:b0:185:4421:250 with SMTP id bb8-20020a170902bc8800b0018544210250mr48418471plb.29.1666881902856;
        Thu, 27 Oct 2022 07:45:02 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t2-20020a170902e84200b00176dc67df44sm1316925plg.132.2022.10.27.07.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 07:45:02 -0700 (PDT)
Date:   Thu, 27 Oct 2022 14:44:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v2 03/16] KVM: x86: Always use non-compat
 vcpu_runstate_info size for gfn=>pfn cache
Message-ID: <Y1qZagwM0dMBjYhe@google.com>
References: <20221013211234.1318131-1-seanjc@google.com>
 <20221013211234.1318131-4-seanjc@google.com>
 <afad5f40-03ef-1380-9bfe-03bbaaed47a9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afad5f40-03ef-1380-9bfe-03bbaaed47a9@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 27, 2022, Paolo Bonzini wrote:
> On 10/13/22 23:12, Sean Christopherson wrote:
> > Always use the size of Xen's non-compat vcpu_runstate_info struct when
> > checking that the GPA+size doesn't cross a page boundary.  Conceptually,
> > using the current mode is more correct, but KVM isn't consistent with
> > itself as kvm_xen_vcpu_set_attr() unconditionally uses the "full" size
> > when activating the cache.  More importantly, prior to the introduction
> > of the gfn_to_pfn_cache, KVM _always_ used the full size, i.e. allowing
> > the guest (userspace?) to use a poorly aligned GPA in 32-bit mode but not
> > 64-bit mode is more of a bug than a feature, and fixing the bug doesn't
> > break KVM's historical ABI.
> 
> I'd rather not introduce additional restrictions in KVM,

But KVM already has this restriction.  "struct vcpu_info" is always checked for
the non-compat size, and as above, "struct vcpu_runstate_info" is checked for the
non-compat size during its initialization.

> actually easy to avoid this patch by instead enforcing that attributes are
> set in a sensible order:

I don't care about fixing XEN support, I care about forcing "length" to be immutable
in order to simplify the gfn_to_pfn_cache implementation.  Avoiding this patch
prevents doing that later in this series.

> - long mode cannot be changed after the shared info page is enabled (which
> makes sense because the shared info page also has a compat version)

How is this not introducing an additional restriction?  This seems way more
onerous than what is effectively a revert.

> - the caches must be activated after the shared info page (which enforces
> that the vCPU attributes are set after the VM attributes)
> 
> This is technically a userspace API break, but nobody is really using this
> API outside Amazon so...  Patches coming after I finish testing.

It's not just userspace break, it affects the guest ABI as well.  arch.xen.long_mode
isn't set just by userspace, it's also snapshot when the guest changes the hypercall
page.  Maybe there's something in the XEN ABI that says the hypercall page can never
be changed, but barring that I don't see how to prevent ending up with a misaligned
cache due to the guest enabling long mode.

  int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
  {
	struct kvm *kvm = vcpu->kvm;
	u32 page_num = data & ~PAGE_MASK;
	u64 page_addr = data & PAGE_MASK;
	bool lm = is_long_mode(vcpu);

	/* Latch long_mode for shared_info pages etc. */
	vcpu->kvm->arch.xen.long_mode = lm;
