Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8735C7EF77
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 10:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404331AbfHBIi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 04:38:56 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38514 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404321AbfHBIiz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 04:38:55 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so76282742wrr.5
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2019 01:38:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P3tN8hyVu/1rvIEnIJgiZUpPyry7kC//HDrNGU4LrOY=;
        b=jIGCdyR6sY37tw86U+DtHr0+YU4T45n4gbDufPoylZocAii4zfzsiY42SKyW9rlRbY
         +zmJ9xTg0mmllB/kThSXz95BNxjBU5PT0bTy369IlexxTqrrpu+0cg+o3sPVRWaW2FC+
         d0NU5wUmYes+YFvGSsnBeWtpHyQxPk5SW219o8DptUJhpirb0JMF38XfmqFB4vvXtNsi
         CE7jAplwt1F11T55FdxFKCzwRXUtq6Kd25kqkhwaiMhITDOGXaHbN8EtRldw14vrrJJv
         wv0I337M8WT7ze7imyLBt4J42y6c1v0JRGw73BnixQbhkLMR/QPj1nxrlA7jfslACQlL
         LOOA==
X-Gm-Message-State: APjAAAUYVAWmQxIfGfpnzazc6Wq24LWo4EIIVoe9n7VZqCaaSYoy1plZ
        qMYsQ5LepTBqNVVJY6aXr+2+ZQ==
X-Google-Smtp-Source: APXvYqz/g6gdVXMJql0snDFkEgsVaPP5ySOr1zSYLcZjwfcT2WdfDBfS1404UrPoIEPcrPsHrjtU0A==
X-Received: by 2002:a5d:6406:: with SMTP id z6mr55322693wru.280.1564735133718;
        Fri, 02 Aug 2019 01:38:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4013:e920:9388:c3ff? ([2001:b07:6468:f312:4013:e920:9388:c3ff])
        by smtp.gmail.com with ESMTPSA id i13sm67487079wrr.73.2019.08.02.01.38.52
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 01:38:53 -0700 (PDT)
Subject: Re: [PATCH] KVM: Disable wake-affine vCPU process to mitigate lock
 holder preemption
To:     Dario Faggioli <dfaggioli@suse.com>,
        Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <1564479235-25074-1-git-send-email-wanpengli@tencent.com>
 <04700afaf68114b5ab329f5a5182e21578c15795.camel@suse.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <36f54918-171d-cf72-818e-dc8cec7cd3b0@redhat.com>
Date:   Fri, 2 Aug 2019 10:38:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <04700afaf68114b5ab329f5a5182e21578c15795.camel@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/08/19 14:57, Dario Faggioli wrote:
> Can't we achieve this by removing SD_WAKE_AFFINE from the relevant
> scheduling domains? By acting on
> /proc/sys/kernel/sched_domain/cpuX/domainY/flags, I mean?
> 
> Of course this will impact all tasks, not only KVM vcpus. But if the
> host does KVM only anyway...

Perhaps add flags to the unified cgroups hierarchy instead.  But if the
"min_cap close to max_cap" heuristics are wrong they should indeed be fixed.

Paolo
