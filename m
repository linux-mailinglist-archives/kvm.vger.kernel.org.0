Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAD620A599
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 21:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406655AbgFYTRu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 15:17:50 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27209 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406645AbgFYTRt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 15:17:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593112667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J38ngMZJtTtBdVA8eYEqJFndDS5GW+zAky5LFHFZ/7A=;
        b=YXfyYursobhimqw9hSZU6q68NoDCU/+SPgLXVKN2rawVn1Nmrx8BbPaiezVzHLhk4mSZZQ
        ETRKSE63+1GToPzG+AkU34LlDOQz5Z0ucdG93vokGtFLgFD6ZcTQKgy2ac0E7XkHVu/sOs
        FTaWdeev0Cxsq9rv/QgU7fpphhdUXwg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-aJ2U-SXgOVONxAGGuYGhZQ-1; Thu, 25 Jun 2020 15:17:46 -0400
X-MC-Unique: aJ2U-SXgOVONxAGGuYGhZQ-1
Received: by mail-wr1-f71.google.com with SMTP id w4so5961187wrm.5
        for <kvm@vger.kernel.org>; Thu, 25 Jun 2020 12:17:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J38ngMZJtTtBdVA8eYEqJFndDS5GW+zAky5LFHFZ/7A=;
        b=LI/CBrFHpS3nkZzqxxN6kFDXSWaD2awqMBC79lrr8YcLULFCtcuMVxUcCbgVDv6eYt
         sMh4rIb3gOWOJGZ3EdwKLth1GSCPuyHa2VM0VbDw7EYynZMWPAnrf71792qcn6by5e2F
         +Pd2wcc7maZSUK9F26GNw45I/yB4coMzdpiZDupsjYMjpfZ9k2YnuoY0MBkvJ8ovQc6S
         bTcXeQDY7oUQ6KNTu6dSKvV8OslxLeJLGXPWZj9ixjOjh/k/AEqIMboUjbzhFHE+Kn/l
         gah7YFGiXIfHbLVGEatQVZL/BktYKa4PsPXYHtDpoKxMPmFiQ6F4uWuuLXMvEqzcfYI+
         GaSg==
X-Gm-Message-State: AOAM5330zUOi2vs4x7MEKlqoNEn3yNRTI2rlOTGWIC2Umsapo26dOdnp
        f/YJ4MxyjfZ5foUexVGUn5E1Al2OGzrpXTSuY8PwoIoOQ/S08nD1Kv72qd4T5WNgdG/TMW4BnCJ
        FC/OJBy9fvJ9A
X-Received: by 2002:a1c:a557:: with SMTP id o84mr5109207wme.42.1593112664936;
        Thu, 25 Jun 2020 12:17:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5BqoIX/ELFZbPQHGk873NSICGvrldasPFnkx2+JgnbovuGxvzE0spmqPRHYFprZ8tZUVwXg==
X-Received: by 2002:a1c:a557:: with SMTP id o84mr5109193wme.42.1593112664732;
        Thu, 25 Jun 2020 12:17:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91d0:a5f0:9f34:4d80? ([2001:b07:6468:f312:91d0:a5f0:9f34:4d80])
        by smtp.gmail.com with ESMTPSA id z25sm13193792wmk.28.2020.06.25.12.17.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 12:17:43 -0700 (PDT)
Subject: Re: qemu polling KVM_IRQ_LINE_STATUS when stopped
To:     Kevin Locke <kevin@kevinlocke.name>, kvm@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>
References: <20171018174946.GU5109@tassilo.jf.intel.com>
 <3d37ef15-932a-1492-3068-9ef0b8cd5794@redhat.com>
 <20171020003449.GG5109@tassilo.jf.intel.com>
 <22d62b58-725b-9065-1f6d-081972ca32c3@redhat.com>
 <20171020140917.GH5109@tassilo.jf.intel.com>
 <2db78631-3c63-5e93-0ce8-f52b313593e1@redhat.com>
 <20171020205026.GI5109@tassilo.jf.intel.com>
 <1560363269.13828538.1508539882580.JavaMail.zimbra@redhat.com>
 <20200625142651.GA154525@kevinolos>
 <1fbd0871-7a72-3e12-43af-d3c11c784d83@redhat.com>
 <20200625185651.GA177472@kevinolos>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <80754688-d05f-11a3-b25e-955b5ee0ca0b@redhat.com>
Date:   Thu, 25 Jun 2020 21:17:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200625185651.GA177472@kevinolos>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/20 20:56, Kevin Locke wrote:
>> Windows 10 can use the Hyper-V synthetic timer instead of the RTC, which
>> shouldn't have the problem.
>
> That's great news!  Since I'm able to reproduce the issue on a
> recently installed Windows 10 2004 VM on Linux 5.7 with QEMU 5.0, is
> there anything I can do to help isolate the bug, or is it a known
> issue?

You need to enable Hyper-V enlightenments, with something like

-cpu host,hv_vpindex,hv_runtime,hv_synic,hv_stimer,hv_reset,hv_time,hv_relaxed

on the QEMU command line.

Thanks,

Paolo

