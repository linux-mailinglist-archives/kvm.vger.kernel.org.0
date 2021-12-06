Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BB846A0FA
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 17:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239259AbhLFQSR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 11:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380396AbhLFQRZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 11:17:25 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9879BC061D7E;
        Mon,  6 Dec 2021 08:08:20 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id t9so23468701wrx.7;
        Mon, 06 Dec 2021 08:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CI1AANkxv/1yNv+fQtXkIMb7xcl0y3xE+kXaERDG6uA=;
        b=bISI35b0ErVvkvwIr9KeYD5FKJS8JeIAQWSnxf6VMJT7LXV/mqLFOFNXElyHwaTgyc
         v2TRhYzqhnMiCTvuemStIZ6TQuwzg+PkvF3DGU8cWklKLQ5V2qqOO9xnxSlc/cycqUew
         t+R2MMUsegSq3GDm0KWw/25fBZZ2x3M6m8Hfi+oGj65EmYd4qvOxvYi4drgZ87+oOE6F
         eDiSiqTJv/A0x7rzN7Wtj0QHqvJI7IQ7ZCJRh+q86Amn/T7vVK/NoZdP+3FFB+k++EB8
         b0nWMINHsj3Nm3Dwn7tf5Se1ewifVQL1OXT6mIX7Y6B+GhxvVGOhQS4mxYwVBgwOivOv
         0P7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CI1AANkxv/1yNv+fQtXkIMb7xcl0y3xE+kXaERDG6uA=;
        b=1qTjQ9IiUMazvsZE82p3Txr6ltkAByXemAtQZCRWiwxA2Ske5Y7MalVIaRFCx2oHxR
         vu9RCnbcoRUEP2CQQ/W/qOsSz33is9aW9RCld3juIOd2kYTCyvw+El21Xq3BfQJmz7Uy
         ZdvCDaMwy96Cz62EfkxfNhh284KJHJVPcaGRvaPUTA8gRnaQ+vN9WExdYz+3TKhObby8
         WAitCIWq5aMq2Rse/sduZmQz+WrRrXZQFspCv5eAiZrzf+GkwQxIlGQdETn79h1Pavz+
         pJAChhO5bnlolGKN/Mutay80D9ZOWvGfP5Zew6wiya0HtoY4VqWYEqNaly4EcHKL/J2Q
         WcUA==
X-Gm-Message-State: AOAM532OtdJhdYj1of7Kh3PytPFgxKh73uA8s+b/PXbm3d7vY+VLzbrG
        R67g6OOSxSF9PA232Q3Fnqs=
X-Google-Smtp-Source: ABdhPJx7fKl/HP4q0dvvQcxU11yyNS1xS6wS4ixY02Moy6KVSatxpw+qV5I7v9YFqFqix8iCZxdfOA==
X-Received: by 2002:adf:fe81:: with SMTP id l1mr45434300wrr.522.1638806899024;
        Mon, 06 Dec 2021 08:08:19 -0800 (PST)
Received: from hamza-OptiPlex-7040 ([39.48.147.147])
        by smtp.gmail.com with ESMTPSA id u23sm12505903wru.21.2021.12.06.08.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 08:08:18 -0800 (PST)
Date:   Mon, 6 Dec 2021 21:08:13 +0500
From:   Ameer Hamza <amhamza.mgc@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com
Subject: Re: [PATCH v2] KVM: x86: fix for missing initialization of return
 status variable
Message-ID: <20211206160813.GA37599@hamza-OptiPlex-7040>
References: <87ee6q6r1p.fsf@redhat.com>
 <20211206102403.10797-1-amhamza.mgc@gmail.com>
 <Ya4uR7I/7yvrgl6c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya4uR7I/7yvrgl6c@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06, 2021 at 03:37:43PM +0000, Sean Christopherson wrote:
> On Mon, Dec 06, 2021, Ameer Hamza wrote:
> > If undefined ioctl number is passed to the kvm_vcpu_ioctl_device_attr
> > function, it should return with error status.
> 
> No, if anything KVM should do KVM_BUG_ON() and return -EIO, because @ioctl is
> completely KVM controlled.  But I'd personally prefer we leave it as is, there's
> one call site that very clearly invokes the helper with only the three ioctls.
> It's not a strong preference though.
Thank you for your response. I agree with you, but I think in my
opinion, it would be nice to resolve coverity warning. Let me update the
patch according to your suggestions anyway.

Thanks,
Hamza.
