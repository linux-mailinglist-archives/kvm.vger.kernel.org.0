Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC1F52721
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 10:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730981AbfFYIwA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 04:52:00 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46784 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730525AbfFYIwA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 04:52:00 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so16820172wrw.13
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2019 01:51:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=BBA1NG64/5TLBLCMBIsPT7OuaVblZH5y/WjnLqDq5V4=;
        b=sgLZ0iEPWCwJjPEeriHntt232y0Q6pyZ4f/rPxsqSl/N0m2MirYy6anFBN9VoJK4s3
         NfN4xGB+6gHq9e6yQW1i43miQ6ThlM+1UVvYj+E0K/TGw8VwcRTQfGEYM71+o+lUXOu6
         gqWw6dqf1b1QhvsSpMw5NcDlvfnjw+m9u07iTYWyrC1Xs1i3Nr21G/K7NR/JH0lD2WzJ
         pq8od2emY0Si88ADzl58MXjVtjHbaCMnG2d6w1r+R27Muv+HL0kvJSGUuphDeJUHoX0f
         iWiZA80vBiwO59zC9DgML80N0grMYB0QGwglvDPdzSj2mwRA7Xd4CmTE+hIETSrAu8g5
         uWhw==
X-Gm-Message-State: APjAAAUcbU+tJwCZ+IDjtYkCUel8lFafYVcD9xM8roGY7PpvPmFEDHRv
        xOMXw/r0EjdVE7Qk9ixx8BXKGg==
X-Google-Smtp-Source: APXvYqzkzahTsy2h4q4Bbr4cVKVsmUX5pYjfwji2TCSk1Qtj+xupmSpq2fY6tN0lC5lp5RaUdVvY4Q==
X-Received: by 2002:adf:afde:: with SMTP id y30mr52581369wrd.197.1561452718089;
        Tue, 25 Jun 2019 01:51:58 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id y19sm2392289wmc.21.2019.06.25.01.51.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 01:51:57 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH] x86/kvm/nVMCS: fix VMCLEAR when Enlightened VMCS is in use
In-Reply-To: <CEFF2A14-611A-417C-BC0A-8814862F26C6@oracle.com>
References: <20190624133028.3710-1-vkuznets@redhat.com> <CEFF2A14-611A-417C-BC0A-8814862F26C6@oracle.com>
Date:   Tue, 25 Jun 2019 10:51:56 +0200
Message-ID: <87lfxqdp3n.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Liran Alon <liran.alon@oracle.com> writes:

>> On 24 Jun 2019, at 16:30, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>> 
>> 
>> +bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmptr)
>
> I prefer to rename evmptr to evmcs_ptr. I think it’s more readable and sufficiently short.
> In addition, I think you should return either -1ull or assist_page.current_nested_vmcs.
> i.e. Don’t return evmcs_ptr by pointer but instead as a return-value
> and get rid of the bool.

Actually no, sorry, I'm having second thoughts here: in handle_vmclear()
we don't care about the value of evmcs_ptr, we only want to check that
enlightened vmentry bit is enabled in assist page. If we switch to
checking evmcs_ptr against '-1', for example, we will make '-1' a magic
value which is not in the TLFS. Windows may decide to use it for
something else - and we will get a hard-to-debug bug again.

If you still dislike nested_enlightened_vmentry() having the side effect
of fetching evmcs_ptr I can get rid of it by splitting the function into
two, however, it will be less efficient for
nested_vmx_handle_enlightened_vmptrld(). Or we can just leave things as
they are there and use the newly introduced function in handle_vmclear()
only.

-- 
Vitaly
