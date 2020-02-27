Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 537D0172301
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 17:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbgB0QRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 11:17:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34525 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728059AbgB0QRZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 11:17:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582820243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vl9va9Y7cJ6ymCeu03nfFSmMSB4nCWJrrOeNw2XCL7I=;
        b=g16EY1SPGKpEKi7ZmxHYTYM80TNl+477H7ZVJhfBNTa9LSU0B3w0VYOEbOdJ9T50AO5ivM
        jTp328CkpHX1w6K5vRCp/1hjFzemeDpAvnRDfbBbpW0RVXOiyJrLf1rrEygXa1J0lr6eFJ
        MtA5q0W5aC6WNpAl8c9IcYBk6n86Z20=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-9Cnc8xi9N9mDJAyLVlJ5NA-1; Thu, 27 Feb 2020 11:17:21 -0500
X-MC-Unique: 9Cnc8xi9N9mDJAyLVlJ5NA-1
Received: by mail-qk1-f200.google.com with SMTP id 206so1403094qkd.21
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2020 08:17:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vl9va9Y7cJ6ymCeu03nfFSmMSB4nCWJrrOeNw2XCL7I=;
        b=dJ5UEC2K30hbI8sJS2ENJzd0dUsE6qOtGPSL2OoqZ31ORwcd9d4FPvyY/YRlzvHegV
         WOYI7P1rEzyjBW/OL6awlC1eJ4X3nfgOCVzfyNs78fUrtl1rgy+tQP0HyyZDRDj77O8P
         L5dj2gU+paIkJ8/3lMnLqTOkYukx5m3SJw8FKheD1TlyL/q5lQ1b3DmbzA7cAMNagbzb
         xIEreqf29Oc/k84k/FQre6qxDsRLul6TbKZQNpkPcImENvrWWtDjxHonbCdSWFNJFREu
         klFuHlinPJ7XkDjmmYYoT5v85CtBDGVDZHqSmFho2rRlwidUa05EyoblXqtV1kicRHVa
         FxPw==
X-Gm-Message-State: APjAAAXriEQuQkQPhvleCK3ruuwLuB9zXuugk3hCSUMuZ+YjBpHNCpd3
        rktdRTes9d/Ir8EVmL/1wBD9RvzjNvZfZiVxRtmHV7dRU1JL4qcg/Mh7eDGv6s59izHQuwP35is
        glXb9XAWLVKmw
X-Received: by 2002:a0c:ea8b:: with SMTP id d11mr433892qvp.5.1582820241090;
        Thu, 27 Feb 2020 08:17:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqyomCLAbwWfEviBt/tlNWD0BZoRIimYYB4J0eVJzAS0+Q8JPApepCJISASF2MqTgm742iGvAw==
X-Received: by 2002:a0c:ea8b:: with SMTP id d11mr433864qvp.5.1582820240849;
        Thu, 27 Feb 2020 08:17:20 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id l16sm3249919qkk.118.2020.02.27.08.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 08:17:19 -0800 (PST)
Date:   Thu, 27 Feb 2020 11:17:18 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Jay Zhou <jianjay.zhou@huawei.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wangxinxin.wang@huawei.com,
        weidong.huang@huawei.com, liu.jinsong@huawei.com
Subject: Re: [PATCH v4] KVM: x86: enable dirty log gradually in small chunks
Message-ID: <20200227161718.GF180973@xz-x1>
References: <20200227013227.1401-1-jianjay.zhou@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200227013227.1401-1-jianjay.zhou@huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 27, 2020 at 09:32:27AM +0800, Jay Zhou wrote:
> It could take kvm->mmu_lock for an extended period of time when
> enabling dirty log for the first time. The main cost is to clear
> all the D-bits of last level SPTEs. This situation can benefit from
> manual dirty log protect as well, which can reduce the mmu_lock
> time taken. The sequence is like this:
> 
> 1. Initialize all the bits of the dirty bitmap to 1 when enabling
>    dirty log for the first time
> 2. Only write protect the huge pages
> 3. KVM_GET_DIRTY_LOG returns the dirty bitmap info
> 4. KVM_CLEAR_DIRTY_LOG will clear D-bit for each of the leaf level
>    SPTEs gradually in small chunks
> 
> Under the Intel(R) Xeon(R) Gold 6152 CPU @ 2.10GHz environment,
> I did some tests with a 128G windows VM and counted the time taken
> of memory_global_dirty_log_start, here is the numbers:
> 
> VM Size        Before    After optimization
> 128G           460ms     10ms
> 
> Signed-off-by: Jay Zhou <jianjay.zhou@huawei.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

