Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E11BC1A1FE3
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 13:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgDHLeD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 07:34:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29904 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728454AbgDHLeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 07:34:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586345641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iMpv1Tcf8msq6CIz6hAZaaOwWt8dkcRjoWBRfrYNwKk=;
        b=RoRVKKv8OqqSmOdsNBjN+SXCfrC6dR9pT5+lcHua/Ex+qQDyNWTC0wvqN/+IE349BXb7rJ
        DCBWeZFn9iUKNIQDUzuUtaAMAA6z9vlh4Ms9L0viXFQDWQe+SJ8B+CXWwQ2YaPz53qEI2N
        eXIJPskYhxi9bTFUGZ8VFpj3Vk0JCfc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-m5QBPROTNievY7VaJKtw9Q-1; Wed, 08 Apr 2020 07:33:59 -0400
X-MC-Unique: m5QBPROTNievY7VaJKtw9Q-1
Received: by mail-wr1-f69.google.com with SMTP id q9so3777216wrw.22
        for <kvm@vger.kernel.org>; Wed, 08 Apr 2020 04:33:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iMpv1Tcf8msq6CIz6hAZaaOwWt8dkcRjoWBRfrYNwKk=;
        b=XPNEqS2lTrJe3XRjyXjhgxDrWrT7rz5qz9ZAli1Zx43wI0fdyJ6wqj0V7ZOvVeWDCn
         7mnZfw7twufu/h9hzR5q5m3MGLAyGhrMo1NdxY2jOaEKNpux936qL3JF+OWuzZPe78y3
         quldApXWh3MhyLyqPv7G78aFPw2wZ0HpJfTUOwVeFviRCWBIgQavd67l2UkMLsQuNj0r
         uBPl4hpF6x4Vyfe3XpQBwcc8wFvUkbuXXrO9BA8EEc5s32yB9T0bZIhyfYbbmPNUmwjo
         yqwuroipZJV1QoV11GV1vqt+HXfJXuvnymhqrUP5PJV/Ww9QUpAR0qu/2HDCZCEggu1G
         yrdQ==
X-Gm-Message-State: AGi0PubdXxsU29CrptbMBDecosk7yVhKmQBafDom5iB2NmOl66mgM3ve
        0sway01dY3sXrCjz0w0M6DOiaD24oHrNIz+1g0RPlcYSAQ2gD3/ucKZw0RZcL+sI44KIaPaGScH
        RM5FNB5j3i9Be
X-Received: by 2002:a1c:3281:: with SMTP id y123mr4239278wmy.30.1586345637882;
        Wed, 08 Apr 2020 04:33:57 -0700 (PDT)
X-Google-Smtp-Source: APiQypLT538fz8uSoawd2IFWIE2g4SRUOixPL/PauE1AvjtumpV89MF+Ihgn7usDfr2aRZ/BhKLoLQ==
X-Received: by 2002:a1c:3281:: with SMTP id y123mr4239265wmy.30.1586345637681;
        Wed, 08 Apr 2020 04:33:57 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id f63sm3148639wma.47.2020.04.08.04.33.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 04:33:57 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: s390: Return last valid slot if approx index is
 out-of-bounds
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+d889b59b2bb87d4047a2@syzkaller.appspotmail.com
References: <20200408064059.8957-1-sean.j.christopherson@intel.com>
 <20200408064059.8957-3-sean.j.christopherson@intel.com>
 <20200408122138.71493308@p-imbrenda>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <40b325c7-ca24-3513-b2fa-1e9397c9e353@redhat.com>
Date:   Wed, 8 Apr 2020 13:33:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200408122138.71493308@p-imbrenda>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/04/20 12:21, Claudio Imbrenda wrote:
> on s390 memory always starts at 0; you can't even boot a system missing
> the first pages of physical memory, so this means this situation would
> never happen in practice. 
> 
> of course, a malicious userspace program could create an (unbootable) VM
> and trigger this bug, so the patch itself makes sense.
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

What about using KVM just for isolation and not just to run a full-blown
OS (that is, you might even only have the guest run in problem state)?
Would that be feasible on s390?

Thanks,

Paolo

