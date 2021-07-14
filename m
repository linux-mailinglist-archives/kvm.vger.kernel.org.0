Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226423C8532
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 15:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbhGNNYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 09:24:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55829 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232058AbhGNNX4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Jul 2021 09:23:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626268864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+fntq9dxK/DsvMDb1vmj39FQnBcJ0Sqj0F7MADcjTnk=;
        b=bVncbu38tH9UfwNj8FBBG/XxFgOV2gr0EZEJUypARLyH+gittYt6httFi8OHN+hq6+vrnj
        3KhRwXVLLutCE4bnbGJ8DFnHGiM8dpTJONP/OV+yH4p2ebvOUNL5l/iVDg8qko5aGWfpLP
        5cb0z0aT7o/7/VEYAzFkAigsSXHhGzQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369--30h2EeyOXm7otvJJIYeXg-1; Wed, 14 Jul 2021 09:21:03 -0400
X-MC-Unique: -30h2EeyOXm7otvJJIYeXg-1
Received: by mail-ed1-f69.google.com with SMTP id j7-20020aa7c4070000b02903a4b519b413so1233149edq.9
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 06:21:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+fntq9dxK/DsvMDb1vmj39FQnBcJ0Sqj0F7MADcjTnk=;
        b=H3oknq13VrBV/re/bCVBkfmeKZ05NTw+OPGNU8SOGEsHPgkAKhmoPuXF5VB7qbzNrD
         ZgNBQC4prSae+pS2iU8cPzF0eCShfExKTWE5wR/gF+nXlEPGOwUcECzQTSnGFIxDBBmu
         xC//Tqb5Lqv+27FWIOYm+3S9RIn4/2whk0r0kXMe/kIjDuDyMIchzh2Zi8N1jZBq8X1X
         D0W2975/k98g2JkMvCww5cHdvo4sLwBBSad+S9YGaOFpcP0IXTpInWDT78KOS6G3si32
         QdKp2RaAr+00jXbRUotk2bXz0mL/fxQ8IsdUqJ+GfquGr0IR0hWFlP3vbcDOvXWBWj8C
         Dy9w==
X-Gm-Message-State: AOAM533XRp+wwNkYHHvOKgrTLuA4UvOFCsw7MmK24XE7WNzlkAhPRri5
        MoZNL+aGCKXmEj5xtTZ4Q/eIV4j/If6NYq96FNlrXLD2Om5IiW8Lz+16WcX8R0aUFsTQcpD9/e9
        7klwQ5loQ8GeGGaWlsMfVuov1bKZ5OuIjYQQwdEkmz/E774v98ItG5JvoqrHd7HrJ
X-Received: by 2002:a05:6402:17d3:: with SMTP id s19mr13544062edy.49.1626268861920;
        Wed, 14 Jul 2021 06:21:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyL7BSCePriyxKihJPYAItdtydFUidngy/E8P+iCKdpMyGjTTXvx+4VpuJJqgrbrMXY5WRlJw==
X-Received: by 2002:a05:6402:17d3:: with SMTP id s19mr13544026edy.49.1626268861714;
        Wed, 14 Jul 2021 06:21:01 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p26sm788024ejn.112.2021.07.14.06.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 06:21:01 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 6/6] x86/kvm: add boot parameter for setting max number
 of vcpus per guest
In-Reply-To: <62679c6a-2f23-c1d1-f54c-1872ec748965@suse.com>
References: <20210701154105.23215-1-jgross@suse.com>
 <20210701154105.23215-7-jgross@suse.com>
 <87h7gx2lkt.fsf@vitty.brq.redhat.com>
 <1ddffb87-a6a2-eba3-3f34-cf606a2ecba2@suse.com>
 <878s292k75.fsf@vitty.brq.redhat.com>
 <62679c6a-2f23-c1d1-f54c-1872ec748965@suse.com>
Date:   Wed, 14 Jul 2021 15:21:00 +0200
Message-ID: <8735sh2fr7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Juergen Gross <jgross@suse.com> writes:

> On 14.07.21 13:45, Vitaly Kuznetsov wrote:
>
>> Personally, I'd vote for introducing a 'ratio' parameter then so
>> generally users will only have to set 'kvm.max_vcpus'.
>
> Okay.
>
> Default '4' then? Or '2 ^ (topology_levels - 2)' (assuming a
> topology_level of 3 on Intel: thread/core/socket and 4 on EPYC:
> thread/core/package/socket).

I'd suggest we default to '4' for both Intel and AMD as we haven't given
up completely on cross-vendor VMs (running AMD VMs on Intel CPUs and
vice versa). It would be great to leave a comment where the number comes
from of course.

-- 
Vitaly

