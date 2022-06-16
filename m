Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C7554E90E
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 20:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbiFPSFT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 14:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238582AbiFPSFP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 14:05:15 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4D349B71
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 11:05:13 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 31so1910012pgv.11
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 11:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AFEyk3br0FmY0rM/k22+knnd84H9/6UyLVs1yQqOmsI=;
        b=BpuVx4OB7bipxxww8pPuELFOuZ/FTXJuPqc4ZbgvYEECyo2FzpiPuVOfnumF/52T9i
         00eszt60moz3Je5hA20LOszZC8bWYzlbGPXD/XHUjiLPPEUei7o3W66M6covw8XGtr+e
         cHJaY0a5FQf94b1LVv8BvKfcUkZlUyt7SE2BApLMg8CFszsJZag5g1Ngz34nZGaIVbyh
         C6+2m4stG99zKti55uKQjhftSJYv18+cZ7LiY1assrgFJPWlpzw+0FNTPHDBCWbOCGsC
         d6bZ5qj930404y4jdkrtQJdXkc4Neypw8xU8u+ocwBpkFGGeuL7bXE9rWtcsWdQbBKw1
         Eu0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AFEyk3br0FmY0rM/k22+knnd84H9/6UyLVs1yQqOmsI=;
        b=l9+U7OABxXPS68ba2xGkSeAw3FWvXB74VG8jqL3/ZV/DvotBwunzj/7jUAf2mzXf8L
         8uCfURKV4Kki4J6g7+o/kfyXJhjbKYSwfvQ+Atp90Zu3UQr7v4Qx0bIjnitHwZaQ23V7
         Uj7mZMSNB+mVj5II/wBCSBZItopFM5yfhtL8PPcrxh6eolsKu7o2oCk43pK6vtb3E8Vv
         oHM0Z1F0U7ao4iN5TQtxE7cQtBKz5fnip2k+KV81YoA86R+lYWjv02QXsTFdukgeqC7L
         sMTGpmk7UsxJTwdt2O1rh0qsNFQo4NH1iCo2Us1ySVc+Tt0quRQU+o2S9GzcUvRkVgHX
         fEZg==
X-Gm-Message-State: AJIora9M/fSkunMZX9RllOnc8RAITFDnmoPPX08gDJpFG4qVLn35+zxm
        x0vu+2RyTUEV5iCJIF6FEF8MHg==
X-Google-Smtp-Source: AGRyM1vwByP5SE3HSqJJxXVfuu2sUqko6W26PPM6hUp+T+x7wR6sg6mgEZFTF3V/SjfjtZMiV0FJ8A==
X-Received: by 2002:aa7:9728:0:b0:51b:e78e:b333 with SMTP id k8-20020aa79728000000b0051be78eb333mr5890627pfg.36.1655402712991;
        Thu, 16 Jun 2022 11:05:12 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id y1-20020a63ad41000000b003fae8a7e3e5sm2064426pgo.91.2022.06.16.11.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 11:05:12 -0700 (PDT)
Date:   Thu, 16 Jun 2022 18:05:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v2 5/5] KVM: Hoist debugfs_dentry init to
 kvm_create_vm_debugfs() (again)
Message-ID: <Yqtw1PqSlisZO+jU@google.com>
References: <20220518175811.2758661-1-oupton@google.com>
 <20220518175811.2758661-6-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518175811.2758661-6-oupton@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 18, 2022, Oliver Upton wrote:
> Since KVM now sanely handles debugfs init/destroy w.r.t. the VM, it is
> safe to hoist kvm_create_vm_debugfs() back into kvm_create_vm(). The
> author of this commit remains bitter for having been burned by the old
> wreck in commit a44a4cc1c969 ("KVM: Don't create VM debugfs files
> outside of the VM directory").
> 
> Signed-off-by: Oliver Upton <oupton@google.com>

Heh, with the above changelog, shouldn't this be?  :-)

  Signed-off-by: Oliver "Works on my Machine" Upton <oupton@google.com>

Reviewed-by: Sean Christopherson <seanjc@google.com>
