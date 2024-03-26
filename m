Return-Path: <kvm+bounces-12717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 873E588CD7A
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 20:48:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B33361C3C21B
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 19:48:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5C1913D267;
	Tue, 26 Mar 2024 19:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tr9ln9mE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C958B380;
	Tue, 26 Mar 2024 19:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711482494; cv=none; b=M1a2boz7eJMafDyFhW5KGqkC2kuou0tWLDR9X8XCObgujgDWB69vT/HZoEG+MVWv0vnyj2/+oZiYdzG0aPyzJwWuUwiL5WeN86nKXsmyEup7CPpb/Qkfc+1TcqFNp+rM+QYnVMniA22n1lgJDxmJvicaA+lFJbo1tZ9LBHmfBeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711482494; c=relaxed/simple;
	bh=9cmXfVQI/nC9ykIDRPwIkUayK3sJamHkua2d6Tcdjzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UfsE28Uh/pE1DpK3G8HGBJvKbx0k+yTfiOihuL7kWorjyDw3H+ZsbcpZFioXT4/ADfHoJy4oMP/Choloq6/ekTXGaNyF/4o9wfxxhr3U7gDAz1J0xjSgYf8wb+2D9TdiQwSzCVR0rQP1kwsaSwqudQuWNlMNwqvOZhSt3hHbHSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tr9ln9mE; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1e0fa980d55so7828225ad.3;
        Tue, 26 Mar 2024 12:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711482492; x=1712087292; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MxBAPr9eXOadeecJbaBW+PIKQfHxWzuOy7OIoDoAlhI=;
        b=Tr9ln9mEwIHpI19N0/C0EJpHKXphn2mtuT1W4AriiX3AMp+IC90mvOmZY0EkBc6hni
         7xtayoWudk30MUKKbxSebe4a3w35kCJelhjlEDtWrKTdDOdYjHGnSBPTaMEKz54ACylt
         US9Ba4RepM5uko/vevEd5MCFCJWrBHE0tF2FOQRcr+mz4ftZNhjnDy/XqKeORp+mUQ6Q
         PngtZ2G5uG6rRIWrmqZo5JgXHIQ7uxp7WydV0al2qtBVVoM/txNvSubMQFNFMXA2OdMS
         vuK4mKagjZLvNTPGeHC/54EfGPT3sQkb1CC7vS5dmKwdpeB1ox3B0jHtndpOJQF9CQD9
         BSVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711482492; x=1712087292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MxBAPr9eXOadeecJbaBW+PIKQfHxWzuOy7OIoDoAlhI=;
        b=dPFb6IAKBHEHlFkv933l1+rLflMyTDbckn8ppF9CCRte3maIvSunw7vJJ+faOY0nlG
         hJQ3u16mcWL3kub4Zo1oAb1DbQY3MTk6dH3MCjOv66RSugdu9YuM45wlA5iI5UN7fcwv
         xhoUv20bg3k3IO6be9VyWjfUSH0x23Wv3BXfbNjj8aOwiRMhyvfut6DtpzZiX5Meif6H
         8J5QVNQC6m5eYqBnISyYIa3hKtK8F72KXzEdLDXTmokRCb4zOH352EK9gFW3cSbhS2eH
         uphluOVbvHj4gD8rvMzkkRrDgam12hyZj/dy8KigcpF8RjMDAbFrS198oT69/reO1xrY
         PdKA==
X-Forwarded-Encrypted: i=1; AJvYcCUzqbbZPzVoT2I+hKrK/6ljfnOU5pz+A7BojdrrzPOyJTi9/DFhYrNYbT6a88SBhFnus5FYBQnW6fjjkRbJC3EL1UKBb+AspdT76T6JZb8l11CJWEbbBCVixhXjM0NmkGLykwrb+jfI3eDUhIXejZnzAceoW8/icGzySq5Tig==
X-Gm-Message-State: AOJu0YzckDkl2GLga01cdSgXWykF2RUM3hvm4q6/2o+jE5xnEcHRQ5pG
	8Qfyq32Ssov0EndUAG2AkG4hcOsvpKWbRYKj1+4rDRVwdkevvRzY
X-Google-Smtp-Source: AGHT+IHgG6MA5Lsu+aw0wxyCe4+UncFf8kJs1/g6C00v9EoIyHznZ9wyUpauWmcrhILSNtqUOtgwbw==
X-Received: by 2002:a17:902:ea11:b0:1e0:a731:ea4d with SMTP id s17-20020a170902ea1100b001e0a731ea4dmr2248814plg.62.1711482492054;
        Tue, 26 Mar 2024 12:48:12 -0700 (PDT)
Received: from fedora (c-73-170-51-167.hsd1.ca.comcast.net. [73.170.51.167])
        by smtp.gmail.com with ESMTPSA id p7-20020a170902e74700b001e0b5d4a2a8sm5279877plf.149.2024.03.26.12.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 12:48:11 -0700 (PDT)
Date: Tue, 26 Mar 2024 12:48:09 -0700
From: Vishal Moola <vishal.moola@gmail.com>
To: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: akpm@linux-foundation.org, hughd@google.com, david@redhat.com,
	rppt@kernel.org, willy@infradead.org, muchun.song@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH 3/3] s390: supplement for ptdesc conversion
Message-ID: <ZgMmec2paNA0GFwY@fedora>
References: <cover.1709541697.git.zhengqi.arch@bytedance.com>
 <04beaf3255056ffe131a5ea595736066c1e84756.1709541697.git.zhengqi.arch@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04beaf3255056ffe131a5ea595736066c1e84756.1709541697.git.zhengqi.arch@bytedance.com>

On Mon, Mar 04, 2024 at 07:07:20PM +0800, Qi Zheng wrote:
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -206,9 +206,11 @@ static void gmap_free(struct gmap *gmap)
>  
>  	/* Free additional data for a shadow gmap */
>  	if (gmap_is_shadow(gmap)) {
> +		struct ptdesc *ptdesc;
> +
>  		/* Free all page tables. */
> -		list_for_each_entry_safe(page, next, &gmap->pt_list, lru)
> -			page_table_free_pgste(page);
> +		list_for_each_entry_safe(ptdesc, next, &gmap->pt_list, pt_list)
> +			page_table_free_pgste(ptdesc);

An important note: ptdesc allocation/freeing is different than the
standard alloc_pages()/free_pages() routines architectures are used to.
Are we sure we don't have memory leaks here?

We always allocate and free ptdescs as compound pages; for page table
struct pages, most archictectures do not. s390 has CRST_ALLOC_ORDER
pagetables, meaning if we free anything using the ptdesc api, we better
be sure it was allocated using the ptdesc api as well.

Like you, I don't have a s390 to test on, so hopefully some s390 expert
can chime in to let us know if we need a fix for this.

