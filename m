Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E29585755
	for <lists+kvm@lfdr.de>; Sat, 30 Jul 2022 01:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbiG2X3M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 19:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbiG2X3J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 19:29:09 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96167E0E8
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 16:29:08 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id e69so4693867iof.5
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 16:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csp-edu.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=qWNh7vOk9tCkYV94WwXKMJ4uEd3sFIr85O9CxOfUKiQ=;
        b=wQRaueezeuI5pT4oYhFHZhZMItthSUgguL7GFYaB68jVps//cv0JYxK90b/gVoI05n
         h8dk3+3t6WieMLwz6z1FkKimPbVmxBxmwHfZ2H2GauMe/JDVDscps2uZS6q2n5ehoxyw
         K54ymHUibx6A+RwjmsE+sATpqcBcstkpP+aMgjfMXtSD1T7G06Bm/3FjtmkNfhzv8Yxq
         zj3bPFJ9BbBbJ5lQtFHs3M4iw3Y8yxFUXHwDZvz4iUR1t+dFmIS535MsNySc4XOqDTJN
         AzfiIGVwL8pvMskr8ehS/xgY2ZzFjfGB0VG+4x4NwHQxpcKiTtHsv6uQyoYdrTZlQsBx
         13sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=qWNh7vOk9tCkYV94WwXKMJ4uEd3sFIr85O9CxOfUKiQ=;
        b=BCx46wadmi637S/9GY6qzErEHx2+/Vx35Q7sbhuaCb/FCmYr0Zj2yVG3y9YG+lkfBX
         pUWe4HC+XjVbpeeC4bU5gwMB2f7TDQa1wEMXdWxVduoywPL81vXigEO3IHsBQ6nthOJp
         SPpBmppIXVrNQu139odzrlQQ63xNY95pyzbBUQSG+qiW0BKhjs3+5Z8mDHw6932WGvVr
         e3xpl5zmQ9rRTnJ+IYYNtvxramoaq/gn84yU7HyZGKn1glZ+nKBgsyM4HFAS3cQM/Yl4
         eXhmMdmXBZFZLQlIwVGuZkm2/2eKWqhFUQcQizkCV0/UimYr8XMmix5vRdUke/j4sySX
         yQBA==
X-Gm-Message-State: AJIora+qPZZ9aiATfts9rp8JAeri/Z8ZIBYFFvSwYbDXAovlg4PrlYhN
        Uyt2RnPPc64C9PyXgGegHRTV+w==
X-Google-Smtp-Source: AGRyM1uRQjDAUWSoc11u2QbNyEFqJJaHT/kHhRAen2+cI88tCY46m5+6iYzrx08XaKia2PfQSYlqDA==
X-Received: by 2002:a05:6638:12d4:b0:33f:aaab:8d84 with SMTP id v20-20020a05663812d400b0033faaab8d84mr2274213jas.67.1659137348018;
        Fri, 29 Jul 2022 16:29:08 -0700 (PDT)
Received: from kernel-dev-1 (75-168-113-69.mpls.qwest.net. [75.168.113.69])
        by smtp.gmail.com with ESMTPSA id y14-20020a5e870e000000b0067bd7f5f964sm2244967ioj.7.2022.07.29.16.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 16:29:07 -0700 (PDT)
Date:   Fri, 29 Jul 2022 18:29:07 -0500
From:   Coleman Dietsch <dietschc@csp.edu>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] KVM: x86/xen: Fix bug in kvm_xen_vcpu_set_attr()
Message-ID: <YuRtQ/GHc3poAmHG@kernel-dev-1>
References: <20220728194736.383727-1-dietschc@csp.edu>
 <YuOPDpy+RqD09n3j@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuOPDpy+RqD09n3j@kroah.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 29, 2022 at 09:41:02AM +0200, Greg KH wrote:
> On Thu, Jul 28, 2022 at 02:47:37PM -0500, Coleman Dietsch wrote:
> > This crash appears to be happening when vcpu->arch.xen.timer is already set and kvm_xen_init_timer(vcpu) is called.
> 
> What does "this crash" refer to ?
> 
> > 
> > During testing with the syzbot reproducer code it seemed apparent that the else if statement in the KVM_XEN_VCPU_ATTR_TYPE_TIMER switch case was not being reached, which is where the kvm_xen_stop_timer(vcpu) call is located.
> 
> Please properly wrap your kernel changelog at 72 columns.
> 
> Didn't checkpatch.pl complain about this?
> 

I believe I made the mistake of editing the patch file directly so it was
on me for forgetting to run checkpatch.pl manually.

> thanks,
> 
> greg k-h

Thanks for the feedback Greg, I believe I have (at least these) issues
resolved in the next version of the patch.
