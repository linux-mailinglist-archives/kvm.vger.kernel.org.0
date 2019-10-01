Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDCCC3A79
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 18:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389904AbfJAQ2t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 12:28:49 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41468 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729455AbfJAQ2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 12:28:49 -0400
Received: by mail-io1-f68.google.com with SMTP id n26so21037464ioj.8
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2019 09:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UuSvIeEi8G20VLcW5Ido12eQq9cZKtBnUP6W2ckvkM0=;
        b=q/mYD8FUxD+U042+JO6vPaG+9STDLSueo96mUhMwNjNiAOEf+/9FjDhmcf0lvNeDyo
         ZlssgVG8+Sj9PB+DCB1RZDRAVyhsLkoW0LRz0zGfJL4OZGO6RjcYnWiCthKtga5Q6rMM
         5Ylygng9dVxGxXV53b0ZHgEIn7mYCkCcMrQ6z2HUPlDcYiVCgiCs3DDJFVcMjKPToxBh
         sA6qXsV/9qVGqkScjkpH2hnonQUw2Dg6hdgJ2Bhiemod0jd9pG0DklXhcURT91cuDtug
         gcntbWDAkaHS1oAQCwYy/KVLcATYtMqPofPNRg8L4/UIJEenRB7Br36HRkgiW/+6N0Ig
         BGWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UuSvIeEi8G20VLcW5Ido12eQq9cZKtBnUP6W2ckvkM0=;
        b=JIbYMVI6rjo5wlwkRh5BC00CesGxYue/7kORYJT801cdc7ePK0NVou6VUT8kIpT8Ve
         DJoXAs0gn7fnF0UKzOTlBf08SiHC4S34qJIq86wGieX4P1ZcFRYp0qhe6zxVQNugDTr0
         T58KIIfIoZxS6XlU3OFaxJDNrR0/p5F0B715ZsA3CLFmdd3qLoUaMtYMbPbd6WkVMLKQ
         fyhE/MAjykwFTWNnSwbraWTl563A/4skFkI/ur8Zerzw+RJrcpUj6W76K6SSG6XhAH4J
         M+JqRvPRkCn2VSkxJ0T5KuqDs0parNu4NdIp2oKrJdXlZAIdb4dVLJSXTwwO8Bnpobzg
         t30g==
X-Gm-Message-State: APjAAAWwxMSdcCRLcyhp2OqXcxzl00DuvYDqRBHTads2JTvYuiu2q+Cc
        Q+XvD1zqykw4D6HUPUL/yaJb8oALd+Rn2WuODavbgw==
X-Google-Smtp-Source: APXvYqx7oohTB0nR7IB9oZL2Nl6qSGUU3K3j39VIdFW99cCivWQmR8DtaLDroXZSXCwBvDHTq/pp2UDsEzLx+NEWADE=
X-Received: by 2002:a92:4a0d:: with SMTP id m13mr25937997ilf.119.1569947328519;
 Tue, 01 Oct 2019 09:28:48 -0700 (PDT)
MIME-Version: 1.0
References: <20191001162123.26992-1-sean.j.christopherson@intel.com>
In-Reply-To: <20191001162123.26992-1-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 1 Oct 2019 09:28:37 -0700
Message-ID: <CALMp9eT+kkdrDhHW4QHaSHQOeXnpcE2Quhd=kOhZq_y6ydjdJA@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Fix consistency check on injected exception
 error code
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nadav Amit <nadav.amit@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 1, 2019 at 9:21 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Current versions of Intel's SDM incorrectly state that "bits 31:15 of
> the VM-Entry exception error-code field" must be zero.  In reality, bits
> 31:16 must be zero, i.e. error codes are 16-bit values.
>
> The bogus error code check manifests as an unexpected VM-Entry failure
> due to an invalid code field (error number 7) in L1, e.g. when injecting
> a #GP with error_code=0x9f00.
>
> Nadav previously reported the bug[*], both to KVM and Intel, and fixed
> the associated kvm-unit-test.
>
> [*] https://patchwork.kernel.org/patch/11124749/
>
> Reported-by: Nadav Amit <namit@vmware.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
