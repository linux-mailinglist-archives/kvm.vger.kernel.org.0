Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7807A31EE70
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbhBRSfe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:35:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25845 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234891AbhBRSCM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 13:02:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613671246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=knU/yki0BfF5dJoH+kKkOxiLiSgQ2mddkhxf1LFdIuI=;
        b=FyCvK1Wccvh0FNrKzVV79kh8nvk9lToVHig962vZ8ag00QhZb4PBp0AbSgtsc32kzORdXX
        HPQqacazR10+bkqEzBnJm8Aja9GWlYKGkh14sI8eRmcxWmFBFx0kCetXN+JYFgY37YH0fj
        gdW1KInXUClhykNmVwEwX1mpb6M8yhY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-u4C2RYxtN0GBgN2aVlqUOQ-1; Thu, 18 Feb 2021 13:00:44 -0500
X-MC-Unique: u4C2RYxtN0GBgN2aVlqUOQ-1
Received: by mail-wm1-f69.google.com with SMTP id j204so1521107wmj.4
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 10:00:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=knU/yki0BfF5dJoH+kKkOxiLiSgQ2mddkhxf1LFdIuI=;
        b=Dfq1GuCfG4esxpbGVx0PMZXIDJqYgMjPmowoVihSZ8pThY5gxbjhjYM2DzB6RGTK2y
         8JCKxRJvg36wpx7ZwOwKqdeU0/rB8UDJeAKUqtp9/XXXASA+T7fLdDhTV2t+pqH+fTu2
         Ki6ugaVusF7M6A8FdYOZEHf4dFT6JJLvLVFItB8MEGy+KfUehXc79Iuwe5TP5o/Wvxx/
         dOjlDuHcLCBXw8NyMv0Qw057BY1sOEVXsydZujOLzrEYVDMZnLkYTrPt69LUstUdZWMs
         LT+hgmWID1fZAAUlw2AT4873XcjOGv/r5AafLUTZSFjtAakphZG0m3m1U4KWoNaWcxaI
         vQNA==
X-Gm-Message-State: AOAM533M49PMsJQQ/MR5gA5/v72gkfmsh1Jk/fIBLpltTlXuiTv0WlgP
        2r9oiJBozSjEzB6eE0brMuylVE/AYnVFMX8oIRImDfG6J06EiU+wTxARvFgxTQ1F8A1/dpeGMab
        +qGcIR0c45O/T
X-Received: by 2002:a5d:5104:: with SMTP id s4mr5336465wrt.277.1613671242968;
        Thu, 18 Feb 2021 10:00:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxg81dCsuwIpBmnRINMv5sFy4QWWKQMpP2/bYb3VgK6odiPlu1XN3GP4HB1vH47LzUx80nnSw==
X-Received: by 2002:a5d:5104:: with SMTP id s4mr5336452wrt.277.1613671242790;
        Thu, 18 Feb 2021 10:00:42 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e16sm12302377wrt.36.2021.02.18.10.00.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 10:00:41 -0800 (PST)
Subject: Re: [PATCH] KVM: nSVM: prepare guest save area while is_guest_mode is
 true
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jroedel@suse.de,
        mlevitsk@redhat.com
References: <20210218162831.1407616-1-pbonzini@redhat.com>
 <YC6m8xoRUDtn3V+y@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cf1b338c-68bc-6e7e-1a10-98bc653d34ce@redhat.com>
Date:   Thu, 18 Feb 2021 19:00:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YC6m8xoRUDtn3V+y@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/02/21 18:42, Sean Christopherson wrote:
>> The bug is present since commit 06fc7772690d ("KVM: SVM: Activate nested
>> state only when guest state is complete", 2010-04-25).  Unfortunately,
>> it is not clear from the commit message what issue exactly led to the
>> change back then.  It was probably related to svm_set_cr0 however because
>> the patch series cover letter[1] mentioned lazy FPU switching.
>
> Aha!  It was indeed related to svm_set_cr0().  Specifically, the next patch,
> commit 66a562f7e257 ("KVM: SVM: Make lazy FPU switching work with nested svm"),
> added is_nested() checks in update_cr0_intercept() to merge L1's intercepts with
> L0's intercepts.

Yeah, the problem is I don't understand why 06fc7772690d fixed things in 
11 year old KVM instead of breaking them, because effectively this patch 
is reverting it.

I don't care _that_ much because so much has changed since then; the 
world switch logic is abstracted better nowadays, and it is easier to 
review the change.  But it is weird, nevertheless.

Paolo

