Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6F554D23E
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 17:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfFTPgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 11:36:55 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34802 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFTPgy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 11:36:54 -0400
Received: by mail-qt1-f193.google.com with SMTP id m29so3663908qtu.1
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 08:36:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=vtY4pO6pnEy7zUizy6kb7ppyyGMbiZZTG+R8FaWK93c=;
        b=uApw+1yOPJ7AbFhc4ggexYgqkK0LfaJErAgGW2+gbOI5NA0akV3hnH5Tn4LJ6qFsWc
         viXFgzqqDwVDHdud+hFaHLNvHu2hoWb1fiuuAOndVIt5lbBCnw0kuUeBVFR9AWXhcXOV
         rhLPzEiPLCxVlMpOp/CcJDnFIlqvFecIbAk5YM1tUB3CRymdVB2JgZtl6Jz9NIGnI7/x
         xrw/20bVNcWBjPj2aC404ZAMCe0NJbRrgwfLAIA3jcs1qbmwYtmwpa/vt/FX9GdNNMqi
         s6BbT7pijwVx0feouEY9nk3xZJFzqRKNRGPSEXrG/wt2c8Vr2qdO8TmULr10hSyYq0MW
         zFqQ==
X-Gm-Message-State: APjAAAUDE1H3jjL5Xx2qjoqp5yImzwAOOGhvvqcREc8I9K6hm/CxvUeS
        CmrofQCkfshMpLuKphTAJ/u9OA==
X-Google-Smtp-Source: APXvYqyK6gIa2B32mpauKI9zUONgbUKtzrXACDNvM5CtwsIRGmI3o1w95PMCi4LZiUFmb/XM9BNnXA==
X-Received: by 2002:a0c:960e:: with SMTP id 14mr39349569qvx.31.1561045013865;
        Thu, 20 Jun 2019 08:36:53 -0700 (PDT)
Received: from redhat.com ([64.63.146.106])
        by smtp.gmail.com with ESMTPSA id c23sm1449qke.111.2019.06.20.08.36.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 08:36:53 -0700 (PDT)
Date:   Thu, 20 Jun 2019 11:36:50 -0400
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
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 05/20] hw/i386/pc: Add documentation to the e820_*()
 functions
Message-ID: <20190620113132-mutt-send-email-mst@kernel.org>
References: <20190613143446.23937-1-philmd@redhat.com>
 <20190613143446.23937-6-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190613143446.23937-6-philmd@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 13, 2019 at 04:34:31PM +0200, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  include/hw/i386/pc.h | 37 +++++++++++++++++++++++++++++++++++--
>  1 file changed, 35 insertions(+), 2 deletions(-)
> 
> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
> index 7c07185dd5..fc66b61ff8 100644
> --- a/include/hw/i386/pc.h
> +++ b/include/hw/i386/pc.h
> @@ -293,9 +293,42 @@ typedef enum {
>      E820_UNUSABLE   = 5
>  } E820Type;
>  
> -ssize_t e820_add_entry(uint64_t, uint64_t, uint32_t);
> +/**
> + * e820_add_entry: Add an #e820_entry to the @e820_table.
> + *
> + * Returns the number of entries of the e820_table on success,
> + *         or a negative errno otherwise.
> + *
> + * @address: The base address of the structure which the BIOS is to fill in.
> + * @length: The length in bytes of the structure passed to the BIOS.
> + * @type: The #E820Type of the address range.
> + */
> +ssize_t e820_add_entry(uint64_t address, uint64_t length, E820Type type);
> +
> +/**
> + * e820_get_num_entries: The number of entries of the @e820_table.
> + *
> + * Returns the number of entries of the e820_table.
> + */
>  size_t e820_get_num_entries(void);
> -bool e820_get_entry(unsigned int, uint32_t, uint64_t *, uint64_t *);
> +
> +/**
> + * e820_get_entry: Get the address/length of an #e820_entry.
> + *
> + * If the #e820_entry stored at @index is of #E820Type @type, fills @address
> + * and @length with the #e820_entry values and return @true.
> + * Return @false otherwise.
> + *
> + * @index: The index of the #e820_entry to get values.
> + * @type: The @E820Type of the address range expected.
> + * @address: Pointer to the base address of the #e820_entry structure to
> + *           be filled.
> + * @length: Pointer to the length (in bytes) of the #e820_entry structure
> + *          to be filled.
> + * @return: true if the entry was found, false otherwise.

I don't actually care whether it's @E820Type, #E820Type or just type,
we should be consistent. I also find this style of documentation
underwhelming. what is to be filled? length or the structure?
upper case after : also looks somewhat wrong.

Same applies to other comments too.

> + */
> +bool e820_get_entry(unsigned int index, E820Type type,
> +                    uint64_t *address, uint64_t *length);
>  
>  extern GlobalProperty pc_compat_4_0_1[];
>  extern const size_t pc_compat_4_0_1_len;
> -- 
> 2.20.1
