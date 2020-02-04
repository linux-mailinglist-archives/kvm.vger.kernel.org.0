Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E51F1151C80
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 15:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgBDOrX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 09:47:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49093 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727261AbgBDOrW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 09:47:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580827640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lw+gzAo8DOLFDe3zbMMR3xycrnPKgKMJnAjOPL2s5GI=;
        b=UFycp+9+xTO0Z0TreDd4xLl0gkqsqikaaz3gc4AQx8O5r05BJ9B5PcXxRAf5U8jJqP26Te
        1PCX6GX0ipnZufrTrcqHcTwCLHneQUQhyyj3JzcrMgbOfCr5qFHr7BgesjfXr+9SLpdKr3
        ObAsXg8oq/gEd/sJkBduquS8OF/x0Wk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-WxNofdP6NCmgqP8Pyj-Gqw-1; Tue, 04 Feb 2020 09:47:18 -0500
X-MC-Unique: WxNofdP6NCmgqP8Pyj-Gqw-1
Received: by mail-wr1-f72.google.com with SMTP id t6so7211463wru.3
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 06:47:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=lw+gzAo8DOLFDe3zbMMR3xycrnPKgKMJnAjOPL2s5GI=;
        b=LNwt/RhXUrNzvpb14oK+5goNG/hHXDvB2lbtHdoMg4IuH4QDw+uLpK53MQTvbLwP+z
         v5ArrYRNwVW7Lu0cbWgR/0PZVuI2d/NvCnItA1R1THdgBn53JtRX6f64XwMOE63Vk3C/
         Zc/Ocfe1h+dIw4gsuRVv9yTD0D2MEj4eiHiXLrri8pt/9u9Zac4f0AWaar3xkPcFUxww
         ww0PfammtHEzrqtytSWiiO2+ez2vSqGdtPjC4zhy0hqFvQm6SzeRpR2SQ2aZyD81kNSg
         ZGl4Hwm+20NyCVjn6wcsFlsHn5r+2xwYHLp0WtPs0H1SqAsjI2yt+qurkcZPk26Ng0lh
         FM6g==
X-Gm-Message-State: APjAAAUUTNd5GrtQxdR2PcSv25rjqSDMiDAQn1woNj/oz6CHOsWc8ERw
        1/zwewpO68B1kO9eFYXsShweAo2eOGw882zFTQKjnd9F037fvxAHU4LHm6/u3goiTIlSG2IqaQ/
        gNTI73R5f8KIU
X-Received: by 2002:a1c:9c52:: with SMTP id f79mr6200715wme.30.1580827637171;
        Tue, 04 Feb 2020 06:47:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqwGD6gTvtFqqoJhFfXZTOsvAgNVMBX4BDKiIn6c4VC9z32JT86bgANO8n+yzg5d3VzQcSYFJw==
X-Received: by 2002:a1c:9c52:: with SMTP id f79mr6200696wme.30.1580827636998;
        Tue, 04 Feb 2020 06:47:16 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id e17sm17425259wrn.62.2020.02.04.06.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 06:47:16 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>
Cc:     David Laight <David.Laight@aculab.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "x86\@kernel.org" <x86@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: x86: Emulate split-lock access as a write
In-Reply-To: <20200131200134.GD18946@linux.intel.com>
References: <db3b854fd03745738f46cfce451d9c98@AcuMS.aculab.com> <777C5046-B9DE-4F8C-B04F-28A546AE4A3F@amacapital.net> <20200131200134.GD18946@linux.intel.com>
Date:   Tue, 04 Feb 2020 15:47:15 +0100
Message-ID: <87y2timmto.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Exiting to host userspace with "emulation failed" is the other reasonable
> alternative, but that's basically the same as killing the guest.  We're
> arguing that, in the extremely unlikely event that there is a workload out
> there that hits this, it's preferable to *maybe* corrupt guest memory and
> log the anomaly in the kernel log, as opposed to outright killing the guest
> with a generic "emulation failed".
>

FWIW, if I was to cast a vote I'd pick 'kill the guest' one way or
another. "Maybe corrupt guest memory" scares me much more and in many
cases host and guest are different responsibility domains (think
'cloud').

-- 
Vitaly

