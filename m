Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E72E0184347
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 10:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgCMJIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 05:08:07 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24520 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726365AbgCMJIG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Mar 2020 05:08:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584090485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wl+yNGtuWXWkfGSGtM8HBlvrUGjPCbpwXBezEmRx7rc=;
        b=D/qUCTzwxIcQbTdsaIsPvXZqRr6HZ30Jndwh1cBRVq0D/TDTO7PNiJDsdf00UqUJN6KDT5
        8y59SPxAUCSVy3hByTkzMD59g369z4NdgoeMt30G+R0qKHYys8Ka1Eto3onbDRRrII4E4S
        Yfxbvn4kfwQKhNKUIpz5XHBscYoyQ+8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-rOp1qUxUP6GKTnmd1eCBtA-1; Fri, 13 Mar 2020 05:08:04 -0400
X-MC-Unique: rOp1qUxUP6GKTnmd1eCBtA-1
Received: by mail-wm1-f70.google.com with SMTP id s15so1086194wmc.0
        for <kvm@vger.kernel.org>; Fri, 13 Mar 2020 02:08:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=wl+yNGtuWXWkfGSGtM8HBlvrUGjPCbpwXBezEmRx7rc=;
        b=mpnNQPE87nQ9AOCI6OEvNhN5xFFKf6O5NDBki8LVxixaOCgTaIggL6W0es+a+4EeL1
         eKMfO7dswbrNvwYCbjG+29qMHvpdbdO8j6LCdFo6vF9bVSx6U+atd7NQ4hRqimkmYQKu
         PuS/pPPjtbr4ZHfvBRWESwGp5crO8nyuLPf98jhsFQD2TXitqmSZYDpIh6ezQc1gVr6h
         z6P7+CEYaTtUQm87JWK1krRECPU7/0DJBoN7XIOiK5aN60o9Q1aiXf3BOwzPAdmPsYC4
         4RKP/JW0mBjVKsnDuG+xgjBZnlk6PRPjnHLHWNQv1kNvC5rBv4a/sYyd94vanmj0Ok5Z
         zSCQ==
X-Gm-Message-State: ANhLgQ0eqKqiShJXy9ZsbePpWf15T0Yrmgjv09zdzFM0oHL0+Yzw8MWL
        0EL6U7brqd8eFMOSzDaWx8d5l0SjJ5l+boteSdtzgfAbEKgbDZ89aBnijrn8FR5yiMSuc3MyPUW
        +I5N4hZPNrq/B
X-Received: by 2002:a7b:c4d6:: with SMTP id g22mr4716939wmk.79.1584090483181;
        Fri, 13 Mar 2020 02:08:03 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuuGYVrX3d9NDPj6bLJOiHXmXO+iiPtI2qoFJ6vPVqe8f2YiQ7CXhiXwjGV1CBmokIarAb43A==
X-Received: by 2002:a7b:c4d6:: with SMTP id g22mr4716906wmk.79.1584090482942;
        Fri, 13 Mar 2020 02:08:02 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a1sm39008132wru.75.2020.03.13.02.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 02:08:02 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>, Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: VMX: Micro-optimize vmexit time when not exposing PMU
In-Reply-To: <CALMp9eTSBpaPYKE6toPCbSfCQGhM9M4=1Z1FFBGQ9Bm_pKSpuQ@mail.gmail.com>
References: <1584007547-4802-1-git-send-email-wanpengli@tencent.com> <87r1xxrhb0.fsf@vitty.brq.redhat.com> <CALMp9eTSBpaPYKE6toPCbSfCQGhM9M4=1Z1FFBGQ9Bm_pKSpuQ@mail.gmail.com>
Date:   Fri, 13 Mar 2020 10:08:01 +0100
Message-ID: <877dzor5am.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> On Thu, Mar 12, 2020 at 3:36 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
>> Also, speaking about cloud providers and the 'micro' nature of this
>> optimization, would it rather make sense to introduce a static branch
>> (the policy to disable vPMU is likely to be host wide, right)?
>
> Speaking for a cloud provider, no, the policy is not likely to be host-wide.

Ah, then it's just my flawed picture of the world where hosts only run
instances of the same type/family because it's mych easier to partition
them this way.

Scratch the static branch idea then.

-- 
Vitaly

