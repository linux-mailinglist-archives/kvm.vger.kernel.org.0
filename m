Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 678A3C0C94
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 22:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfI0UWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 16:22:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40988 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbfI0UWs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 16:22:48 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C1FA6C065116
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 20:22:47 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id 190so3035348wme.4
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 13:22:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HpWQUH+bZpFVQAathDrFNRBGbgJ/OKk/HwVBcDJZV3Y=;
        b=nuE1osFeDgOE/xN06mHChl3ANUUFHe0ZfM4+Sn8+J3YboIBQkemN7otAzXVYWAnt8P
         XXlcK7nb9zM+F51X/N1TVM8WEn6LnEWIQoDSERK7c7S3tILwBLA2RAzplnoIkQBbzrqE
         d/VXbj65oFzAaHA4VCeqLUTlx1ZTBKdESScBbhJf7T3Gsxr2ihC+gcG2xKnHyheODztV
         xa6P2RhQueJcnczAbym37lPyMOKOjmELOE4CoB+SuVvivgHsMY83TXXo1TJ3y7B+D/JX
         38s2Xy9D53GM4W5mXrst6XLumdzyEGsZg+kdHnrJSXk6HgK9xmbNvEcfuMxijHeyFC4C
         AtfA==
X-Gm-Message-State: APjAAAVnzvH6AvCgwPIOfT9nXHdIfPvPXWGjMKOpVOXqE4J22ZZrvF4F
        OSNyPh5pHCRA7qB6IZHoSyutfWSgeeFP1el0i0mSp3vh5SfdqFMhRCGuVizJKAZdsQ/pEVPZIQH
        s8LhdlkLSWcyZ
X-Received: by 2002:a5d:6ace:: with SMTP id u14mr4615010wrw.385.1569615766408;
        Fri, 27 Sep 2019 13:22:46 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwkdGlCcHBXXmZg6D7LanB6aSTUDgMp8/vvcujJ0wwRU2P32V6fwgBbo1ZF++jz6bg4B7lZ5g==
X-Received: by 2002:a5d:6ace:: with SMTP id u14mr4614992wrw.385.1569615766165;
        Fri, 27 Sep 2019 13:22:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id z189sm17892522wmc.25.2019.09.27.13.22.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2019 13:22:45 -0700 (PDT)
Subject: Re: [PATCH RESEND v4 1/2] x86/cpu: Add support for
 UMONITOR/UMWAIT/TPAUSE
To:     Tao Xu <tao3.xu@intel.com>, rth@twiddle.net, ehabkost@redhat.com,
        mtosatti@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, jingqi.liu@intel.com
References: <20190918072329.1911-1-tao3.xu@intel.com>
 <20190918072329.1911-2-tao3.xu@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a1156a86-3ec3-da72-306b-1fafa0c369d7@redhat.com>
Date:   Fri, 27 Sep 2019 22:22:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190918072329.1911-2-tao3.xu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/09/19 09:23, Tao Xu wrote:
> +    } else if (function == 7 && index == 0 && reg == R_ECX) {
> +        if (enable_cpu_pm) {
> +            ret |= CPUID_7_0_ECX_WAITPKG;
> +        }

This should be the opposite; remove the bit if enable_cpu_pm is not set.

Paolo
