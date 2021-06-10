Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCCD3A2D06
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 15:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhFJNbj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 09:31:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24581 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230280AbhFJNbi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 09:31:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623331781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hUww2H6mOYMFrVyPJua5qMXJgouUiMizecBkG9cRXMQ=;
        b=K471R+lqPae63nl5yY9YAMlpIjz4y0jhHnCGETskmXVTqIcrYgE4w9TlWkCFjbYTFgkMGh
        6nfPosS9CnzEqoWTeMQ1gpInCx4msMPumR8TMP2usYjR5ewdUJVC2Y7VB27Grx5YqyaOfs
        LruYifPF1MEd6dYp4cjSlQQ3K5QX+Zw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-7uyUrqyoMNWQH5Gnn75Axw-1; Thu, 10 Jun 2021 09:29:38 -0400
X-MC-Unique: 7uyUrqyoMNWQH5Gnn75Axw-1
Received: by mail-wm1-f72.google.com with SMTP id z25-20020a1c4c190000b029019f15b0657dso3000202wmf.8
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 06:29:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hUww2H6mOYMFrVyPJua5qMXJgouUiMizecBkG9cRXMQ=;
        b=uTC4mGp+j9FhQDXSEoW41XZCL48IOeNtAdd1SPKrXzfwg8QKejNUW1YSRPvN6r+VD5
         Qi/74iE386iqu+BARoJwTgAIqOEfNHnF1plaViDPxsWmNBCLoHix+2/a4yuX1kkUI2Vb
         HiaQ3cH9UCGznsivMZg15qzaWFPvv0pFZOjYyQhW1uOcAE4cY1rw9/ATZO0Zf/CVkkj4
         y/HtVOOvCc0PMV3UfHCusiWHPqc64MqLXnfibO5On3C0BJQMrRqfsNWpzwInAJcNZT47
         PPfnlwCAxUzn8w2s0HrcjM6PEpDwfXqKXW4ueRInApVFt/qqkwn6/qeT/kPWtaIEEVCa
         A8hw==
X-Gm-Message-State: AOAM532q/ZKak5nxh9OYxEkI3RSmsGK87AXan/JYuxcnlGJgG1voxJZ0
        /Z7DMbNn92Do+rP07Q1xwNJXiEtpIWBOjvRxozewChKKQ/CkPKVhdKdbYaYJhAAt4dqJdQOhiWm
        RCGxfxf6FtXab
X-Received: by 2002:a05:6000:154c:: with SMTP id 12mr5449703wry.126.1623331777228;
        Thu, 10 Jun 2021 06:29:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvjcRem46QPjln9QkPMp7aRjPQpdNLR+LC2+I4KyWl25z655aAlQqmyfSiC9AjFjCPQJB2Rw==
X-Received: by 2002:a05:6000:154c:: with SMTP id 12mr5449675wry.126.1623331777028;
        Thu, 10 Jun 2021 06:29:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id m3sm3750147wrr.32.2021.06.10.06.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 06:29:36 -0700 (PDT)
Subject: Re: [PATCH 2/9] KVM: x86: Emulate triple fault shutdown if RSM
 emulation fails
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fb0b6a7e8713aeb0319c@syzkaller.appspotmail.com
References: <20210609185619.992058-1-seanjc@google.com>
 <20210609185619.992058-3-seanjc@google.com>
 <87eedayvkn.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <61e9ec9e-d4f5-bea5-942a-21c259278094@redhat.com>
Date:   Thu, 10 Jun 2021 15:29:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87eedayvkn.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/06/21 10:26, Vitaly Kuznetsov wrote:
> So should we actually have X86EMUL_CONTINUE when we queue
> KVM_REQ_TRIPLE_FAULT here?

Yes...

> (Initially, my comment was supposed to be 'why don't you add
> TRIPLE_FAULT to smm selftest?' but the above overshadows it)

... and a tenth patch to add a selftest would be nice to have indeed.

Paolo

