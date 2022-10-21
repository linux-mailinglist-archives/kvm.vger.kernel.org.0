Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B82607F32
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 21:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiJUTlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 15:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiJUTkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 15:40:47 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56B0198446
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 12:40:43 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 204so3502118pfx.10
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 12:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y5Kub3oyocSWTl/XejmtkMUlSMgpTSGJ542v3b15fFs=;
        b=e22cd3ycGxe1vhNw6YtFt+nF2EN4biL9M9o8f2ZYq+vUKdm+bZmUYR4aYK/WMoI+VK
         VjrLz2rb84qmIrR4iuhL78OxatUxpobhy9bulH3oS71MT+z8oUtoqyZcq0nu+GtqYwzE
         IQiFvVuTp5afzUAEJW21mX8qww58a94y6nisjffcGgTrNoAs8+ZOu121+67wzNE1Qztj
         fRqDAm9SYC/+3Q7I2lEVl6wcW2AB0MYL2BvVC2SIwqT+paPkePlDI28sch4lhI9EPkXZ
         bot59j/0KXQQd2rsovyT5qkU2SI3W/KnlmXInuvzeam/3iSfGh3Fg3iCGkBmGUk7B38x
         kgUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y5Kub3oyocSWTl/XejmtkMUlSMgpTSGJ542v3b15fFs=;
        b=aQEEuQ88ufrGBbyXozC8X/gdf2BcdoNBaN5D7GVy0LsDzC6+FhtGNpA+WK9vrpM32Y
         HMeM8M497fSF8b8hUKxdk/DUaGEeJjwgx0fXemLRzMiohML+/WmQztxn5hT9o8SATc68
         gILLh0SjSX/cwcOb3wWd3NhLbQn0NXzwfqk8nyVkSvgCfZAjB12VRcLnjtL8HN9ZCAiQ
         jKu31/dVFgpGgd+ZxQpbxX1c+HEg8UVT05wQ7b1cKeC7RBoPTLmSEfZ+ocbJrkFQed6y
         3DzsBTULhGID6UN1tjpNny2ia/rFu340m4IfFb+jHz1ydZpiUyD/ZbECKqVt6H4B7ATz
         B6gg==
X-Gm-Message-State: ACrzQf1X4YUj5Hwe8EznW+q45QetVPKlXNh1pyc2l0U6NBvyAqwticJB
        3+sMNnVkRZfusq+Zo+yo8oiuFQ==
X-Google-Smtp-Source: AMsMyM4TLsbSsaSVguefvhGZcYd5mnHh9TucImBl/AnEXlazTUYhfLUHdM/T8vnWbhF0uVZeQFsqmA==
X-Received: by 2002:a05:6a00:408c:b0:565:fc2c:8c71 with SMTP id bw12-20020a056a00408c00b00565fc2c8c71mr21037646pfb.82.1666381243244;
        Fri, 21 Oct 2022 12:40:43 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x71-20020a62864a000000b0056b126431eesm1266409pfd.218.2022.10.21.12.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 12:40:42 -0700 (PDT)
Date:   Fri, 21 Oct 2022 19:40:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>,
        "Chandrasekaran, Siddharth" <sidcha@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <Y1L1t6Qw2CaLwJk3@google.com>
References: <20190813115737.5db7d815@x1.home>
 <20190813133316.6fc6f257@x1.home>
 <20190813201914.GI13991@linux.intel.com>
 <20190815092324.46bb3ac1@x1.home>
 <a05b07d8-343b-3f3d-4262-f6562ce648f2@redhat.com>
 <20190820200318.GA15808@linux.intel.com>
 <20200626173250.GD6583@linux.intel.com>
 <590c9312-a21f-8569-9da3-34508300afcc@amazon.com>
 <Y1GxnGo3A8UF3iTt@google.com>
 <cdaf34bc-b2ab-1a9d-22d0-3d9dc3364bf2@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdaf34bc-b2ab-1a9d-22d0-3d9dc3364bf2@amazon.com>
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

On Thu, Oct 20, 2022, Alexander Graf wrote:
> 
> On 20.10.22 22:37, Sean Christopherson wrote:
> > On Thu, Oct 20, 2022, Alexander Graf wrote:
> > > On 26.06.20 19:32, Sean Christopherson wrote:
> > > > /cast <thread necromancy>
> > > > 
> > > > On Tue, Aug 20, 2019 at 01:03:19PM -0700, Sean Christopherson wrote:
> > > [...]
> > > 
> > > > I don't think any of this explains the pass-through GPU issue.  But, we
> > > > have a few use cases where zapping the entire MMU is undesirable, so I'm
> > > > going to retry upstreaming this patch as with per-VM opt-in.  I wanted to
> > > > set the record straight for posterity before doing so.
> > > Hey Sean,
> > > 
> > > Did you ever get around to upstream or rework the zap optimization? The way
> > > I read current upstream, a memslot change still always wipes all SPTEs, not
> > > only the ones that were changed.
> > Nope, I've more or less given up hope on zapping only the deleted/moved memslot.
> > TDX (and SNP?) will preserve SPTEs for guest private memory, but they're very
> > much a special case.
> > 
> > Do you have use case and/or issue that doesn't play nice with the "zap all" behavior?
> 
> 
> Yeah, we're looking at adding support for the Hyper-V VSM extensions which
> Windows uses to implement Credential Guard. With that, the guest gets access
> to hypercalls that allow it to set reduced permissions for arbitrary gfns.
> To ensure that user space has full visibility into those for live migration,
> memory slots to model access would be a great fit. But it means we'd do
> ~100k memslot modifications on boot.

Oof.  100k memslot updates is going to be painful irrespective of flushing.  And
memslots (in their current form) won't work if the guest can drop executable
permissions.

Assuming KVM needs to support a KVM_MEM_NO_EXEC flag, rather than trying to solve
the "KVM flushes everything on memslot deletion", I think we should instead
properly support toggling KVM_MEM_READONLY (and KVM_MEM_NO_EXEC) without forcing
userspace to delete the memslot.  Commit 75d61fbcf563 ("KVM: set_memory_region:
Disallow changing read-only attribute later") was just a quick-and-dirty fix,
there's no fundemental problem that makes it impossible (or even all that difficult)
to support toggling permissions.

The ABI would be that KVM only guarantees the new permissions take effect when
the ioctl() returns, i.e. KVM doesn't need to ensure there are no writable SPTEs
when the memslot is installed, just that there are no writable SPTEs before
userspace regains control.

E.g. sans sanity checking and whatnot, I think x86 support would be something like:

@@ -12669,9 +12667,16 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
         * MOVE/DELETE: The old mappings will already have been cleaned up by
         *              kvm_arch_flush_shadow_memslot().
         */
-       if ((change != KVM_MR_FLAGS_ONLY) || (new_flags & KVM_MEM_READONLY))
+       if (change != KVM_MR_FLAGS_ONLY)
                return;
 
+       if ((old_flags ^ new_flags) & KVM_MEM_READONLY) {
+               if ((new_flags & KVM_MEM_READONLY) &&
+                   kvm_mmu_slot_write_protect(kvm, new))
+                       kvm_arch_flush_remote_tlbs_memslot(kvm, new);
+               return;
+       }
+
        /*
         * READONLY and non-flags changes were filtered out above, and the only
         * other flag is LOG_DIRTY_PAGES, i.e. something is wrong if dirty

