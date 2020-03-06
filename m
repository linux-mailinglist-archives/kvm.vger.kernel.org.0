Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2467817BBD0
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 12:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgCFLis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 06:38:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36707 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726231AbgCFLis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 06:38:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583494727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Spzl07gt6AiHxSswf4FMxeagCVtGBrYL0CA43/3EHAA=;
        b=SI7h45YlI5aXOuXPVuos+GLlbQlME1gHzeW5ZnBmkYKTh/UCtEeEp5/tOpoXoo0cVt4zqb
        V1WhXsj3KsUg34AFLMbttDbsrcy0KZfwaYvQRI+5Q/NhqMY45ksj/B0BoRZ409VJ2RRfkS
        uw1ZbfKB/0fN078Un5qVVOBJUA5IfU8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-NavDlw8MPyi9oISVxdF5wA-1; Fri, 06 Mar 2020 06:38:45 -0500
X-MC-Unique: NavDlw8MPyi9oISVxdF5wA-1
Received: by mail-wm1-f69.google.com with SMTP id r19so786725wmh.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2020 03:38:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Spzl07gt6AiHxSswf4FMxeagCVtGBrYL0CA43/3EHAA=;
        b=feQ2NvW2cO2oSodJGozTO3mGr0oa0cHvxKuPH5bVF0BMbfX9U8GN5uouV7uOVtShoJ
         ls3U36OoenS70pGQMxdw1MgNiwAuyNmraFM5Y2x4ai8ig1XT3t4hNyFRmeuXFOqtDucd
         q2/3VJRbPwKpL6xOlW11nCb5gVoftLvLExFVis/+CAS2uPQ+vfn7pLA2JEwgIz8RU6zo
         VcjWLSUCjgQUiVQaFUqDx+0RyYcLUI0rEQDG4dMxaK3TGzFjBOI+jd9eB1s0bn4YgN09
         bLo8lhYXkdMTV9rW3HLLlZwdQqw4mhKGo+pOgTpEWVbl3Ah5YE2U3aGw6qzvmoNjrNg/
         TwDg==
X-Gm-Message-State: ANhLgQ0qzdhyKy/dORZzG0cjs8PKByUSX0GRvkfYDwteZmFE+cMMY2xa
        1hvh5/Q0uqzhNcrKqTPCd8f2blzarXvab6BIVc0GMFptWGtyiQOVdIU9uLWIg+ZpOLh4AvXzrws
        Up7xvWPVgEEUb
X-Received: by 2002:a1c:e442:: with SMTP id b63mr570773wmh.174.1583494723590;
        Fri, 06 Mar 2020 03:38:43 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuLdMqaEBrFkhWpgZz11Wwa03MCR7/8PlHXB9UcY9iaRG8MEtnrqJPJIvECyJFWVOJbykuMyw==
X-Received: by 2002:a1c:e442:: with SMTP id b63mr570759wmh.174.1583494723368;
        Fri, 06 Mar 2020 03:38:43 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8cd7:8509:4683:f03a? ([2001:b07:6468:f312:8cd7:8509:4683:f03a])
        by smtp.gmail.com with ESMTPSA id 19sm14946335wma.3.2020.03.06.03.38.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 03:38:42 -0800 (PST)
Subject: Re: [PATCH RFC 4/4] kvm: Implement atomic memory region resizes via
 region_resize()
To:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org
Cc:     Richard Henderson <rth@twiddle.net>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org
References: <20200303141939.352319-1-david@redhat.com>
 <20200303141939.352319-5-david@redhat.com>
 <102af47e-7ec0-7cf9-8ddd-0b67791b5126@redhat.com>
 <3b67a5ba-dc21-ad42-4363-95bb685240b9@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2a8d8b63-d54f-c1e7-9668-5d065e36aa1d@redhat.com>
Date:   Fri, 6 Mar 2020 12:38:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <3b67a5ba-dc21-ad42-4363-95bb685240b9@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/03/20 11:20, David Hildenbrand wrote:
> Yeah, rwlocks are not optimal and I am still looking for better
> alternatives (suggestions welcome :) ). Using RCU might not work,
> because the rcu_read region might be too big (esp. while in KVM_RUN).
> 
> I had a prototype which used a bunch of atomics + qemu_cond_wait. But it
> was quite elaborate and buggy.
> 
> (I assume only going into KVM_RUN is really affected, and I do wonder if
> it will be noticeable at all. Doing an ioctl is always already an
> expensive operation.)
> 
> I can look into per-cpu locks instead of the rwlock.

Assuming we're only talking about CPU ioctls (seems like a good
approximation) maybe you could use start_exclusive/end_exclusive?  The
current_cpu->in_exclusive_context assignments can be made conditional on
"if (current_cpu)".

However that means you have to drop the BQL, see
process_queued_cpu_work.  It may be a problem.


Paolo

