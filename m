Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF6B31D0F0
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 20:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhBPT0V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 14:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbhBPT0U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 14:26:20 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E81C061756
        for <kvm@vger.kernel.org>; Tue, 16 Feb 2021 11:25:39 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id e9so6609886pjj.0
        for <kvm@vger.kernel.org>; Tue, 16 Feb 2021 11:25:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6pGhr0lLQTg5Y4WWGGYsJGmCuH6QGJ7ZmH7j+4B6fO0=;
        b=jcMSHmqrBxMlYE72GFYJYYQF9nFoMT8f+DpsnOohzDyd03St4i7DqZo89SaolbnFTi
         e2Ja5TFI5EAPny5wzmltnBh3TnjCIuBMMKD2VbabO0byZD+hbj0fv5xMkgcd96ZcfbF8
         7coS2ZCkbkduIOP7Lir7k+0AXpJBUGYDQqOeb025Ah8HhINiEOq+7OEyYmz3SsTpykf1
         z2T5A7RcJR3wACjRKz5B78r53Y7LSrvjB6CPezaI+HQiOnvRBGUTQf3iDGnSekdZQT8q
         C4Xad8BMkgdPWe5l/EXlqy9ZY8eGBSh1suVbQTPR5DMs/PtewpmyzSk9R5b/Z13UI65f
         rJzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6pGhr0lLQTg5Y4WWGGYsJGmCuH6QGJ7ZmH7j+4B6fO0=;
        b=L+4RjZKhSpZFa98efKl6glPbUgAOarFbpIVBNJpO/ftcW9fBEiqHEhPVWen/mj7qV9
         497p/FGGnuvO+gdZOoyW2IzTTv+ah1woaMsD5xdBveMrFRVNQiVS2dxoTzi33tSUWA3F
         /J8fA+cNH5XqQrQ69Hn3xSKoRhB0MHjhkvVYQxW9YyO/qDD/imrdd5kr7szo+X4twsIK
         yc9Uflml5cdPkEeUPu3lmdUGA4lDrfCNKzdM1i+AzuIQR15iNdo+EAesLv/MW9EStvoA
         Grky4tO+M89skdKwu+W+UC/HR01p+avf6BIwhj0dEWjGOk8pIZxAu8pmqXcq/8gbm9mW
         QBgQ==
X-Gm-Message-State: AOAM530/QLwkdQbkcRYgx6MfsXd3oeTo51DOS3irxz4jb5HcMC7fL7Vu
        VCOTHd+e3qaCMGZYh63CX2o97A==
X-Google-Smtp-Source: ABdhPJzGo17ipEZb1+AmMEOCTgvYjDPeWMOyjad0F6FQnkAP6Tl1TEqdffLRGZ/5kQI2xxLAmUpZZA==
X-Received: by 2002:a17:90b:224f:: with SMTP id hk15mr5582032pjb.31.1613503539177;
        Tue, 16 Feb 2021 11:25:39 -0800 (PST)
Received: from google.com ([2620:15c:f:10:6948:259b:72c6:5517])
        by smtp.gmail.com with ESMTPSA id z16sm3244505pgk.13.2021.02.16.11.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 11:25:38 -0800 (PST)
Date:   Tue, 16 Feb 2021 11:25:32 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v5 05/26] x86/sgx: Introduce virtual EPC for use by
 KVM guests
Message-ID: <YCwcLIyUypf4huX1@google.com>
References: <cover.1613221549.git.kai.huang@intel.com>
 <4813545fa5765d05c2ed18f2e2c44275bd087c0a.1613221549.git.kai.huang@intel.com>
 <eafcdcae-ae66-e717-2f8b-2bdfb8e7d0d5@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eafcdcae-ae66-e717-2f8b-2bdfb8e7d0d5@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 16, 2021, Dave Hansen wrote:
> > Having separate device nodes for SGX driver and KVM virtual EPC also
> > allows separate permission control for running host SGX enclaves and
> > KVM SGX guests.
> 
> Specifically, 'sgx_vepc' is a less restrictive interface.  It would make
> a lot of sense to more tightly control access compared to 'sgx_enclave'.

The opposite is just as likely, i.e. exposing SGX to a guest but not allowing
enclaves in the host.  Not from a "sgx_enclave is easier to abuse" perspective,
but from a "enclaves should never be runnable in the host in our environment".
