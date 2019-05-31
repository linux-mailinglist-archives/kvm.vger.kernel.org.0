Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17FF130AF2
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 11:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfEaJBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 05:01:49 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53730 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfEaJBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 05:01:47 -0400
Received: by mail-wm1-f68.google.com with SMTP id d17so5545996wmb.3
        for <kvm@vger.kernel.org>; Fri, 31 May 2019 02:01:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DTiQsLTxPV2jXrLH/uO3q/GEu7ETuQg2TOaV62LmCWk=;
        b=FQPXe0FygdrhMud+JV126UCPUm+W9g5q496sw5jjm4wt7h2o/BY7g1AO6AGMVwStFq
         84eZ4/Vvbd86hRViB+mWfVoOlBselQzxOq3hJcFhGTxCCs1uVG8cWrWTyusA+KgYWEtb
         bJybZTYRvLDEs6AT3rMtVuqYhf/baEN4n5ZNN9f9vVbIVPREl7ou2FzKbXeRCQZycfIl
         krXgnV1yKwrhoUFSvCe1d42v0KO8g7JyKiAinJKX90g5qEEpYIKR4dPS2PH6dOrumHc+
         XtKKrD3IOpZeZYHE0dxzzH3WzsVEz54YoaJeMqsxGtAra7dm67BKMeRgad04ICKqQisv
         r6fQ==
X-Gm-Message-State: APjAAAV/CQTUfmqzTR5CkL5+RTELIhHkSWkZijdWqzFMGw6FILgqDRZ6
        9F+bhRDegw1nYBdM5T/yv9H1CA==
X-Google-Smtp-Source: APXvYqwPM3bx3DRCNnTfMZ6u9wtiYG9PJ9DNHMH+x0DpAEt/eeZaB2JcBrDF6jH6+F1OyKZC4/zIzA==
X-Received: by 2002:a05:600c:240e:: with SMTP id 14mr4902900wmp.133.1559293305650;
        Fri, 31 May 2019 02:01:45 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id k184sm10942021wmk.0.2019.05.31.02.01.44
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 02:01:44 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: LAPIC: Optimize timer latency consider world
 switch time
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <1558585131-1321-1-git-send-email-wanpengli@tencent.com>
 <20190530193653.GA27551@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <754c46dd-3ead-2c27-1bcc-52db26418390@redhat.com>
Date:   Fri, 31 May 2019 11:01:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190530193653.GA27551@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/05/19 21:36, Sean Christopherson wrote:
>> +u32 __read_mostly vmentry_lapic_timer_advance_ns = 0;
>> +module_param(vmentry_lapic_timer_advance_ns, uint, S_IRUGO | S_IWUSR);
> Hmm, an interesting idea would be to have some way to "lock" this param,
> e.g. setting bit 0 locks the param.  That would allow KVM to calculate the
> cycles value to avoid the function call and the MUL+DIV.  If I'm not
> mistaken, vcpu->arch.virtual_tsc_khz is set only in kvm_set_tsc_khz().

I would just make it read-only.  But I'm afraid we're entering somewhat
dangerous territory.  There is a risk that the guest ends up entering
the interrupt handler before the TSC deadline has actually expired, and
there would be no way to know what would happen; even guest hangs are
possible.

Paolo
