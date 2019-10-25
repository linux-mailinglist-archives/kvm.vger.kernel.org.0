Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27799E49FB
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 13:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501933AbfJYLao (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 07:30:44 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40947 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728673AbfJYLao (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Oct 2019 07:30:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572003043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=XQgc7c2EmFgqK1YzsjkEprNJyWMkfs1IiatZCJFio1E=;
        b=Ic/WLjYJ1YtoGO7kFq4FaSGfQ0CNc76RQq7PkTl3Xe3dzjxDq+tZeKvKpkmCTlfCBSdlI+
        YMICblKS3odvknQDkZqP75nkCeNoeq5S8C7JmNpRcmtQt9fXyW3X1x8OrIjFt5vnebLams
        kuvlQ7R7jRPG5UfvrvoeRCCUBO/nSIc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-tLG_ZGQSPxqVF6IUpYYEGg-1; Fri, 25 Oct 2019 07:30:38 -0400
Received: by mail-wm1-f71.google.com with SMTP id l184so798435wmf.6
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 04:30:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=diUeBXqf+ef0LU9f+k0m+JvYQCeLFALaPsN0dC56DyA=;
        b=cECJIOXnAiwAt5V0nTRu2VePQtXnStCTzZ1OU4cABdsqIrdU/kNBkI5AbjKG8ovRQU
         3OTZUe/2bYbDrzY8H4QUQGtYGg6OFNDEDqJIrNJYoTtDZEhAWBIWl1AsU80S3oQ5bBN/
         jb5CuLDqOVgU5OJKSRwsNVfXbl3h7+Ftzn/kX520T6i08IPkEBgNFqtk7ScShb+E3YPj
         6n5CNf67kH3e/725BHpjOB0/3kNwgl38l8GC+ynWxhGltJGNCFKSQq2b2F0MZi5eegND
         beb5l6PpKX9AZNtJTYk/YGczOFB6gfJRl8msn6sO3pDgqms1jg125EeXc0G6RwLQJyl1
         Z7Lw==
X-Gm-Message-State: APjAAAWPL5hHQey1MGKYaowOljqy26F8MSrS2J8viRKjtGZewH0ISoJ1
        C16+NvlCVEq4TQlgGFpE1jVr5NY2MJ7dFKARVLi73cw7oBYxQf0C8Ar2OoK0KIrYpZqDRJxwQ2Q
        8nPemH4k9iN6z
X-Received: by 2002:a1c:3b42:: with SMTP id i63mr2900362wma.37.1572003037661;
        Fri, 25 Oct 2019 04:30:37 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzXoYaqYCzH4ZJPcTI93A5Us8DE/1OTBXTLo8Zkexfxksh/nlSZ2yvbPcdJxg5uVRBg7ngulQ==
X-Received: by 2002:a1c:3b42:: with SMTP id i63mr2900339wma.37.1572003037401;
        Fri, 25 Oct 2019 04:30:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9c7b:17ec:2a40:d29? ([2001:b07:6468:f312:9c7b:17ec:2a40:d29])
        by smtp.gmail.com with ESMTPSA id r3sm2393185wre.29.2019.10.25.04.30.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Oct 2019 04:30:36 -0700 (PDT)
Subject: Re: [PATCH v3 2/3] kvm: Allocate memslots and buses before calling
 kvm_arch_init_vm
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, John Sperbeck <jsperbeck@google.com>,
        Junaid Shahid <junaids@google.com>
References: <20191024230327.140935-1-jmattson@google.com>
 <20191024230327.140935-3-jmattson@google.com>
 <20191024232802.GI28043@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <22307355-8bf4-92cd-b8c1-66fec7396dea@redhat.com>
Date:   Fri, 25 Oct 2019 13:30:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191024232802.GI28043@linux.intel.com>
Content-Language: en-US
X-MC-Unique: tLG_ZGQSPxqVF6IUpYYEGg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/19 01:28, Sean Christopherson wrote:
> Personally I'd prefer to add labels for each stage of destruction instead
> of abusing the NULL handling of kfree() and kvm_free_memslots(), especial=
ly
> since not doing so forces the next patch to update these gotos.

I'm not sure the two are related, and the NULL handling is definitely a
feature.

Regarding naming the gotos positively vs. negatively, I find the
negative naming slightly easier to review:

=09=09init();
=09=09if (foo())=09=09   /* 1 */
=09=09=09goto out_no_unfoo; /* 1 */
=09=09bar();

=09out:
=09=09unbar();=09=09 /* 2 */
=09out_no_unbar:=09=09=09 /* 2 */
=09=09unfoo();
=09out_no_unfoo;
=09=09uninit();

vs.

=09=09init();=09=09=09 /* 1 */
=09=09if (foo())
=09=09=09goto out_init;   /* 1 */
=09=09bar();
=09
=09out:
=09=09unbar();
=09out_foo:
=09=09unfoo();
=09out_init:=09=09=09 /* 2 */
=09=09uninit();=09=09 /* 2 */

Perhaps I would name the labels "no_enable" and "no_arch_init_vm", but
these patches can be applied first anyway.

Paolo

