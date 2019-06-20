Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 286654D228
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 17:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbfFTP3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 11:29:11 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45481 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbfFTP3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 11:29:10 -0400
Received: by mail-qt1-f196.google.com with SMTP id j19so3552954qtr.12
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 08:29:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=66vLEJcM7c6Ep0GWTtMY1vHR3Uhe7+FRj6/BTTNykpU=;
        b=iq83NK3KIqFMIHIPYPe5TSBo865lTXrRsZ/Bmi1Qj1eMqGnMiKW6YEKJmKmbcf3LEm
         aVE+LvzZdPwSKVfBo1rdLs6xZAdrtbAaOj8xWB+WUKUEgVorGnAzq8M3Ev5HNwHkCnVe
         ucospfMMb5CRn7n9BuKTjkstgwWmSxl4RUZHvLz32gurBzbzHpaaP5v2oCOmV+z6c/T6
         BMsrb5bw7/Uf9TVk4NfMxk9eV8Qy+R8n0zf6xsfH25uxoE1FaRxWeJfx6SOAG8mDf/jR
         7h5l2A89oLkFCgQ2OP2bEF+N74/TnM9cca253Wg2Bd3DWddHn7kqEKgUgq6vFOuKf5QO
         bdAA==
X-Gm-Message-State: APjAAAWvjHwDHHnaezvcv3WcMvnwbvlYrb1j7/RDquQKtqFE/H6yZd8N
        NgGxAzdVkKa42ed9clgCutZ9tA==
X-Google-Smtp-Source: APXvYqxugr5bD/uY7lQvjgwQjgESKc22Rg9fEIHfFOndZ8gi3MhgZvAJPFXwICtfeMN624qAMoTrXw==
X-Received: by 2002:ac8:444c:: with SMTP id m12mr16690819qtn.306.1561044549837;
        Thu, 20 Jun 2019 08:29:09 -0700 (PDT)
Received: from redhat.com (173-166-0-186-newengland.hfc.comcastbusiness.net. [173.166.0.186])
        by smtp.gmail.com with ESMTPSA id j22sm7730qtp.0.2019.06.20.08.29.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 08:29:08 -0700 (PDT)
Date:   Thu, 20 Jun 2019 11:29:06 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <rth@twiddle.net>,
        Rob Bradford <robert.bradford@intel.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Li Qiang <liq3ea@gmail.com>
Subject: Re: [PATCH v2 03/20] hw/i386/pc: Let e820_add_entry() return a
 ssize_t type
Message-ID: <20190620112844-mutt-send-email-mst@kernel.org>
References: <20190613143446.23937-1-philmd@redhat.com>
 <20190613143446.23937-4-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190613143446.23937-4-philmd@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 13, 2019 at 04:34:29PM +0200, Philippe Mathieu-Daudé wrote:
> e820_add_entry() returns an array size on success, or a negative
> value on error.

So what's wrong with int? Does it overflow somehow?

> 
> Reviewed-by: Li Qiang <liq3ea@gmail.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  hw/i386/pc.c         | 2 +-
>  include/hw/i386/pc.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index ff0f6bbbb3..5a7cffbb1a 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -872,7 +872,7 @@ static void handle_a20_line_change(void *opaque, int irq, int level)
>      x86_cpu_set_a20(cpu, level);
>  }
>  
> -int e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
> +ssize_t e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
>  {
>      unsigned int index = le32_to_cpu(e820_reserve.count);
>      struct e820_entry *entry;
> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
> index fc29893624..c56116e6f6 100644
> --- a/include/hw/i386/pc.h
> +++ b/include/hw/i386/pc.h
> @@ -289,7 +289,7 @@ void pc_madt_cpu_entry(AcpiDeviceIf *adev, int uid,
>  #define E820_NVS        4
>  #define E820_UNUSABLE   5
>  
> -int e820_add_entry(uint64_t, uint64_t, uint32_t);
> +ssize_t e820_add_entry(uint64_t, uint64_t, uint32_t);
>  size_t e820_get_num_entries(void);
>  bool e820_get_entry(unsigned int, uint32_t, uint64_t *, uint64_t *);
>  
> -- 
> 2.20.1
