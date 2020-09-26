Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9DD2795AE
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 02:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbgIZAy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 20:54:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30966 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729377AbgIZAyZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 20:54:25 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601081664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GVvDP0oI6L3uDUMk8e8XXQ6jgEEUDuEkkcmuILofjHI=;
        b=L3OG9S03Xs3xVdeTeDzrHeOVpEowF3rV+EYUs3oEtsx61FWJA5htP8C7HP8sCCaQeNnA2I
        ERtBVduJQSH1qrMrhS0CNtbLmgR3ZH1VjpCsgz35wAmYbubevF+CTtsM5b6V+PlkKrE42g
        thKKiJQRcJxfIveiKdnbYBEMxuwplM4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-i_xaQiEAM0SqAgqWbkiDPg-1; Fri, 25 Sep 2020 20:54:22 -0400
X-MC-Unique: i_xaQiEAM0SqAgqWbkiDPg-1
Received: by mail-wr1-f69.google.com with SMTP id l17so1739375wrw.11
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 17:54:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GVvDP0oI6L3uDUMk8e8XXQ6jgEEUDuEkkcmuILofjHI=;
        b=TsrMXQBgL3keHFDdqvV1Mh/aTZTAQVxGs7QLtLYvhOjHqzC17W8gAlqfgxcgQnfKdK
         sW5Q4aae7nhhxxdxFUk9mfVA2GfzbtUHNWAd4fDpebhQg3pCeFd62tMremjIoxKdSTm9
         c4YB2ZxXXp2GXoKN+x4qGu2G+ZO0JaWxIGCHxbH+sd+VYX5dQ8+YgpvztTqfB0I8yPT3
         kHrg1F/FewFXpaI4n0qpPgTakQQdSajWxei0B0eC8gLOKvC/sqrjSfliFEWZAMCepzo4
         EaqyoRYNkSz0PDdEyGQokg5bCbPZakiHl09WZFOgiTkPc0db53bFbSb1XUT0QkScxZ2x
         OaPg==
X-Gm-Message-State: AOAM532hdGQmQOuYJVLNrc5ugA5tb/OwxHdKcBmCPpRn0oqLQhK+mLiq
        1C/HYEqzV1K3Wp+auhmdAO31F01VUb3njLGDhv6qOAj06UdADML0xwRM2q4rLIgSotwK5sU1jAb
        g59L4VapBbkkL
X-Received: by 2002:a5d:5307:: with SMTP id e7mr6944961wrv.215.1601081661238;
        Fri, 25 Sep 2020 17:54:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYrnYxZbzjjIcfHXDku5rIxyway7re5QlxTADpzD53OGu4BLGiAvDapVKDrGNM71WfSS36NA==
X-Received: by 2002:a5d:5307:: with SMTP id e7mr6944943wrv.215.1601081661004;
        Fri, 25 Sep 2020 17:54:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id x67sm741602wmb.25.2020.09.25.17.54.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 17:54:20 -0700 (PDT)
Subject: Re: [PATCH 02/22] kvm: mmu: Introduce tdp_iter
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-3-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c2afbbbc-1203-a4d3-1bf8-77a0e1a5e5e8@redhat.com>
Date:   Sat, 26 Sep 2020 02:54:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200925212302.3979661-3-bgardon@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 23:22, Ben Gardon wrote:
> +	bool done;
> +
> +	done = try_step_down(iter);
> +	if (done)
> +		return;
> +
> +	done = try_step_side(iter);
> +	while (!done) {
> +		if (!try_step_up(iter)) {
> +			iter->valid = false;
> +			break;
> +		}
> +		done = try_step_side(iter);

Seems easier to read without the "done" boolean:

	if (try_step_down(iter))
		return;

	do {
		/* Maybe try_step_right? :) */
		if (try_step_side(iter))
			return;
	} while (try_step_up(iter));
	iter->valid = false;

Also it may be worth adding an "end_level" argument to the constructor,
and checking against it in try_step_down instead of using PG_LEVEL_4K.
By passing in PG_LEVEL_2M, you can avoid adding
tdp_iter_next_no_step_down in patch 17 and generally simplify the logic
there.

Paolo

