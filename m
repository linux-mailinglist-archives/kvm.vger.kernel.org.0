Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3EF3A33E4
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 21:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhFJTYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 15:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbhFJTYt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 15:24:49 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6178DC061574
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 12:22:40 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id fy24-20020a17090b0218b029016c5a59021fso4387140pjb.0
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 12:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q60JAm9iJyX+IT1BVb08j+OKVYIcmui1mNiKIc2o95A=;
        b=FyARXhggC2pK8LeaLL5HzTYgmhxYyXd9tj1XbSmLsO99Ov4/vYm+21l/swFIQTVDLy
         B0KxUZQ9VfHHECcdBtR9tZOyUiLBUDKtk+1e4ECd593H5O9ehHo7mBdAkMBsEm/kGett
         d95PLn0bf1KWgcIZIE62kCCAfnSNKA2VSp48ND88lNtgMeqj22hmdwGoA9wcA7FZPfVO
         gXsgIlqGt0zjTnIAp+Nbu+Vgd297Y5h7I94iBICM1OibHMeNVMyvOpfyprpjHXamRM0g
         +DPEJBJVyng6hN5H7ldwJJH/NkfuHRfbFbxBAfhnJLGCxZsHGeEjA0AI4BBtJ/PXreyt
         MJdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q60JAm9iJyX+IT1BVb08j+OKVYIcmui1mNiKIc2o95A=;
        b=Szt77S4/PeWUFh2yU7puwXJyEjm9lQ4jtPd+DD2rzDiemoeBejcQh0PqNn4kG7HjeB
         ELB9Jhg+yFsRL+eQ0xzIjlhYrH7rXBU3BufWOX6shXiEa8VOj3tk7tltl+CEVM2ECKbA
         zCe8CHvRQNyP9PReUuBQlahKubzHjsq985gB+rxLd9klSacmLxfIDnqQvdwx7ICQQMeo
         TEx1+qnK043eOab0v6IcRJDZX9SqIj6ejJDOSDOaMKhDM8ysZG5tAo8nIKwJUSoq6+Gv
         hm4rB/TxCiTdsYEH9snkW/z7/tMw0Rw2MYwwwj7Khpw7WLsZp8Hlxv7NOd2N7AHgkqy/
         v3JA==
X-Gm-Message-State: AOAM5323apHmCNVXWkE4miW7B7RnVJXF3XS0HGsl2Am1+4+QuxNeb06g
        SDYEIjSIB9paNJIs8ElVV5Ic1g==
X-Google-Smtp-Source: ABdhPJyC58KxFV2meI/htR9vylJrOiDouyjMt32X8u8rqNytwI3x3Lr2z+/BjHCU72ocaVuR4ottZg==
X-Received: by 2002:a17:902:b683:b029:ee:f0e3:7a50 with SMTP id c3-20020a170902b683b02900eef0e37a50mr259675pls.7.1623352959723;
        Thu, 10 Jun 2021 12:22:39 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w142sm3187946pff.154.2021.06.10.12.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 12:22:38 -0700 (PDT)
Date:   Thu, 10 Jun 2021 19:22:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/43] KVM: x86: vCPU RESET/INIT fixes and consolidation
Message-ID: <YMJme5wSgerifcb5@google.com>
References: <20210424004645.3950558-1-seanjc@google.com>
 <6ac56ad5-7475-c99f-0ca4-171bc3da45b5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ac56ad5-7475-c99f-0ca4-171bc3da45b5@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 10, 2021, Paolo Bonzini wrote:
> I'm waiting for a v2 of this; it applies with relatively few conflicts, but
> there were some comments so it's better if you take care of updating it.

Ya, slowly getting there...  Something in this series (I can't even remember what)
sent me into the morass that is unsync shadow pages and I've been thrashing around
in there for a while.
