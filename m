Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0EF31B5E73
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 16:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbgDWO6q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 10:58:46 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25370 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726380AbgDWO6q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 10:58:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587653924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LF1mR98ZsspG6hFlwkveu5fxjM1/WWjBF1lX+wIJ3Ro=;
        b=VszwZczCKuH4Ew12FHv8pVWJPtpKyHKpic787BnkzpP8ldrcCRKPlVHEfMpRS5A7unRdux
        eqMImYW3FQT3frkbiPB/CffbXFwXgdRFW5NKWodTS7sY/7Elvae10NJB3jpRkOd0cDPqfG
        T3LvM7NObS+LcUOv59dYhbaH5c+aN4k=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-RSQ8W4qCMVu5VUfwuSj89Q-1; Thu, 23 Apr 2020 10:58:43 -0400
X-MC-Unique: RSQ8W4qCMVu5VUfwuSj89Q-1
Received: by mail-wr1-f72.google.com with SMTP id f2so2997063wrm.9
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 07:58:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LF1mR98ZsspG6hFlwkveu5fxjM1/WWjBF1lX+wIJ3Ro=;
        b=EDaIy9R0fsSmKXZDC6pXR8binMZhmxR24guTd+burPy30xMc7SwTWGNbO9l8SHq+XI
         BNwxZhmjKIBGrZeFBLsH46de7ymj/69aGrun66KQqU2jfUqv6vq8wk8IR4vKXPdVYMlX
         6B8DoTlU2xIwQ3KEyYawMzwUcS87DmnoHVgBdglvidXPGdM6+ow5KAQEN6UDj7a1zm2U
         kzobRdC7X0x0rP7V880bOG7vh/iEEwv5iqFTGqH4k3rT2kNQhKXbfwuqAb4FpoNieAxO
         SU1Jhec7lo6hRGQW+yvAKNmoB8gv0SWbTf1xepghpXTtYa0RdyjwoH2yjvYs273vv9yJ
         TSwQ==
X-Gm-Message-State: AGi0PuajX+NHLrrk0aMsmsDWyks6ccTUyJIrRqOSGFW3UKVybrZarYQ2
        a3sCI67qK6PkCaH80sRgugJlwDL6GYLkZ2GnfmgX/D1vVo1wX0OIPeQdnGZePJJqHKq6jpV1fGU
        ScwUDhQLkyBAi
X-Received: by 2002:a1c:2e07:: with SMTP id u7mr4598179wmu.74.1587653922526;
        Thu, 23 Apr 2020 07:58:42 -0700 (PDT)
X-Google-Smtp-Source: APiQypI3ZtnwdvQD+OkmsF20U6sOGqkW/h32yM4npR8vKhJowWv1yJktFyWdurcZKl4ZY/nQULGPWA==
X-Received: by 2002:a1c:2e07:: with SMTP id u7mr4598160wmu.74.1587653922284;
        Thu, 23 Apr 2020 07:58:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id 36sm4117329wrc.35.2020.04.23.07.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 07:58:41 -0700 (PDT)
Subject: Re: [kvm PATCH 2/2] KVM: nVMX: Don't clobber preemption timer in the
 VMCS12 before L2 ran
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Makarand Sonare <makarandsonare@google.com>,
        kvm list <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>
References: <20200417183452.115762-1-makarandsonare@google.com>
 <20200417183452.115762-3-makarandsonare@google.com>
 <20200422015759.GE17836@linux.intel.com>
 <20200422020216.GF17836@linux.intel.com>
 <CALMp9eRUE7hRNUohhAuz8UoX0Zu1LtoXum7inuqW5ROy=m1hyQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d1910ba0-13b0-1e82-06d1-b349632149e4@redhat.com>
Date:   Thu, 23 Apr 2020 16:58:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eRUE7hRNUohhAuz8UoX0Zu1LtoXum7inuqW5ROy=m1hyQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/20 19:05, Jim Mattson wrote:
> I don't have a strong objection to this patch. It just seems to add
> gratuitous complexity. If the consensus is to take it, the two parts
> should be squashed together.

The complexity is not much if you just count lines of code, but I agree
with you that it's both allowed and more accurate.

Paolo

