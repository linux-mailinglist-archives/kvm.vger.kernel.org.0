Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA50154B9C
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 20:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgBFTGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 14:06:50 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26627 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727768AbgBFTGt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 14:06:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581016008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vFP4U5ATaHC0RXndwUcuwuU/AxffnBhPUu6Oesq1zsE=;
        b=CMig0ZJZRaAqHlsnvjVsEx+MtxpPk1YT3y+XGps0s9Cep+i9cLmG3DlHH0yKMMLPKiRZ3M
        eNDUCltDDuXwem3fJCR2Q5ZopVAkI88Notwq1/oPhcWp3qfH9uNYerOVhaWrrGBNDjrgyD
        /UQWaWdZZbZO+jjyoz0M6+cy1Zq9Tqc=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-uiWtu35pNva4fAjwVtiT9A-1; Thu, 06 Feb 2020 14:06:46 -0500
X-MC-Unique: uiWtu35pNva4fAjwVtiT9A-1
Received: by mail-qt1-f200.google.com with SMTP id k27so4527957qtu.12
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 11:06:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vFP4U5ATaHC0RXndwUcuwuU/AxffnBhPUu6Oesq1zsE=;
        b=CQyxfmFIMU5HkdWCaONcto2NMre71H1LWCt4XSLbF7/tus486v/GCtx1KAmd2rfUqO
         Zf7PufZbToeGFVe6iFzRFl1P9FMmlZpC7L6Hj0q9SNbF1qU+dR6GxR2ROUiw9moaSmv/
         Hl5ma8yeosJN46sieTqjQ74Lf/beUyEOFXt7R+a8zYSnrEiCVDtaqDzCXeSJkAx2nwze
         OMd2M9l2IasE4+1OI0er23Ox0mFmiGdD7FdrFhDdt+6AIVYJMxeLoOie2LuHNek69byD
         +GjAl55KXDk3MmqYM1CwXL9zNsTePGQhzRduS5r7QWofJVKCV3F5gYIb5IQFLJ65cvmg
         2W6Q==
X-Gm-Message-State: APjAAAXefwlNF46oH/UP4fkp9qfbdM3jbB5evp9CzxixG9wY8LsLw898
        2ilx17S62iTkPtUr+M30u9kAtMczuodt17puCMOUsI0BQUwlaxPsrJfbzhOcYTKURLXAGlzQfOf
        7Hb6/zJ08fXR7
X-Received: by 2002:a37:9d8c:: with SMTP id g134mr3831588qke.128.1581016005751;
        Thu, 06 Feb 2020 11:06:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqwcm5P+4dPwvjCn12J5PDi86Wcm35+8jmeWD2jbAE2DUKQO5334DVnipyStraLYLoHf0dGJ6w==
X-Received: by 2002:a37:9d8c:: with SMTP id g134mr3831559qke.128.1581016005447;
        Thu, 06 Feb 2020 11:06:45 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id m27sm111381qta.21.2020.02.06.11.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 11:06:44 -0800 (PST)
Date:   Thu, 6 Feb 2020 14:06:41 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: Re: [PATCH v5 14/19] KVM: Clean up local variable usage in
 __kvm_set_memory_region()
Message-ID: <20200206190641.GA700495@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-15-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200121223157.15263-15-sean.j.christopherson@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 21, 2020 at 02:31:52PM -0800, Sean Christopherson wrote:

[...]

> @@ -1101,52 +1099,55 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
>  		return -EINVAL;
>  
> -	slot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
> -	base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
> -	npages = mem->memory_size >> PAGE_SHIFT;
> -
> -	if (npages > KVM_MEM_MAX_NR_PAGES)
> -		return -EINVAL;
> -
>  	/*
>  	 * Make a full copy of the old memslot, the pointer will become stale
>  	 * when the memslots are re-sorted by update_memslots().
>  	 */
> -	old = *slot;
> +	tmp = id_to_memslot(__kvm_memslots(kvm, as_id), id);
> +	old = *tmp;
> +	tmp = NULL;

Shall we keep this chunk to the patch where it will be used?  Other
than that, it looks good to me.

Thanks,

-- 
Peter Xu

