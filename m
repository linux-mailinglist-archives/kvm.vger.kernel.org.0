Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464202678B2
	for <lists+kvm@lfdr.de>; Sat, 12 Sep 2020 09:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgILHzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Sep 2020 03:55:50 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53472 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725805AbgILHzq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 12 Sep 2020 03:55:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599897345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CMsih95ppexED5XQI9GoRgCwwBN6vlyz7YM0OAysBhw=;
        b=N0IshfJtP0QuIJNQt79W9Dz8e3VJF/wSlsK7uRYex8RqsbHlwe/ZscGtuhhUOC33qh8v+C
        G7R3WslOAlQ1LubZjL2YcGyyzN7T2DE3q+oISUE7WZlZShcUNatuqMokGdSzgFMXKOzv2d
        72Hf6ZbVhlYakcCYpqkigqSWPd46Fcw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-fqR-jqFfNsibls1iOXJzrQ-1; Sat, 12 Sep 2020 03:55:42 -0400
X-MC-Unique: fqR-jqFfNsibls1iOXJzrQ-1
Received: by mail-wr1-f71.google.com with SMTP id f18so4124272wrv.19
        for <kvm@vger.kernel.org>; Sat, 12 Sep 2020 00:55:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CMsih95ppexED5XQI9GoRgCwwBN6vlyz7YM0OAysBhw=;
        b=h1wcU+5ZJXCsASdlOYt4eKtNaaBtk6r6ZEzWEZnfAw5azZI2/VOaxR3KBu9bxq7ZLe
         Ou4breeYPDtRrPqJEmazVQ9UKqmEaqFNO6Zq/HLRc5SlZhofF7ATezOwp8Q0hwjt60ct
         Udt61Waw1reR+1nqX6/7zA83Bve4/s9hlMM+wE2FlR+teLsUXZVPYbssBb9VL6VJnG4A
         p4wQM0X5nFKaTSxOe5kMcjfctAGI2T2r4hUYga4dJgm1lJpaW9ImbRIi8xVGTacxu3mS
         65vKzC2naDFUQBHH2hjgyMBbnhr4LdeN3T22q5adQCT9D6QEyuCvkbAEqIakM6agrDYT
         HCAw==
X-Gm-Message-State: AOAM533/updrwhZx+M1wx9H/i094vW7yFjvy6OExdw26ANEcEXE1PHqt
        NyA0CbEp/ymYSNMTxK+Erx+VQ2hGXDwPNwhP5HNVXw/qov7WPES3no7fCzeKcPEw09MILJiSmbv
        adLmj2lOG5Igo
X-Received: by 2002:a5d:4d51:: with SMTP id a17mr5739918wru.248.1599897341637;
        Sat, 12 Sep 2020 00:55:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyg6CN+GEydxbMQMopXakFuMzw3iVzO6YDM9LKHVc0oXuGeulvNCjUe0zMburgKy2PGf4Mkag==
X-Received: by 2002:a5d:4d51:: with SMTP id a17mr5739895wru.248.1599897341427;
        Sat, 12 Sep 2020 00:55:41 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id j14sm8882364wrr.66.2020.09.12.00.55.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Sep 2020 00:55:40 -0700 (PDT)
Subject: Re: [PATCH 1/3] SVM: nSVM: correctly restore GIF on vmexit from
 nesting after migration
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20200827162720.278690-1-mlevitsk@redhat.com>
 <20200827162720.278690-2-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ad5cee03-7e2c-1e7a-a5c6-88fa5305224e@redhat.com>
Date:   Sat, 12 Sep 2020 09:55:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200827162720.278690-2-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/20 18:27, Maxim Levitsky wrote:
> However in nested_svm_vmexit we were first were setting GIF to false,
> but then we overwrite this with value from the hsave area.

Do you mean we are overwriting the resulting intercepts with values from
the hsave area?  If so, I can rewrite the commit message but the patch
is good!

Paolo

