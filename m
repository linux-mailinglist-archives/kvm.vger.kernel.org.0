Return-Path: <kvm+bounces-39281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 14C19A45F08
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 13:30:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3184161C10
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 12:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93EEA21CA15;
	Wed, 26 Feb 2025 12:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GIf4v6Ma"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EF41ADC8F
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 12:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740572953; cv=none; b=lY7CFUjsWs6WgN7OLqWqNmdxcihlw1yHsfc2hmfVjskSQ21ZgxAn6cRwqTk4CCp9yv11t4rtG1mMgtm6o3pl6rNQnF7ZWyQF1h9XKvp77Z5WxHnSRjqTW/OlWq8xgTh8/2tnaQ11Y2WwUdGJYRRP/dsonF/jTjm8+v9BpZVR72U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740572953; c=relaxed/simple;
	bh=3tPTH0OfW1bXXoDhOFEtxf7pDN2l1bHuBEJiQV3Y4kc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=idSUe2EYEx2RSvdC5ngdQa1uSD4oIJ/bZMy2PZL8TJYLRS7NSZ32t+jAmDVBQ86BlbWiOCFl2FdbxLAj6v8IoEvYQKIEKgHMPdXw8JUkmSo3lCsQzi1jKfwiYqbw/OW3lTpc2gyQVOwBZIx/9lPt9KA6Y4yMqhSANx8AUN2edZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GIf4v6Ma; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740572950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YqtUsmTYfSl8QjL4A92EdoUfNd8iKRnEclZHB/5oJQc=;
	b=GIf4v6MaC8EmwdwyunN157x5d0PciwgSfRDwuLacPOPDKs3bgUSgL/upyrt60uFWt9Duzb
	bqim0vcGg5T0qV2FNES6nccmnbrdQ5SNlxxdCBuuXlD0uifbeocibCuXM4UM9k3sDxxcXk
	RXq4dp61DUMCTLIvFN8vgFj6IC5Smw8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-wqWTOn8rPwytpM5T5OUEGw-1; Wed, 26 Feb 2025 07:29:08 -0500
X-MC-Unique: wqWTOn8rPwytpM5T5OUEGw-1
X-Mimecast-MFC-AGG-ID: wqWTOn8rPwytpM5T5OUEGw_1740572948
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43942e82719so48672245e9.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 04:29:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740572947; x=1741177747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YqtUsmTYfSl8QjL4A92EdoUfNd8iKRnEclZHB/5oJQc=;
        b=f3ZKNDWUddxBbQ2IxpOV2xWzFpTdpWpBN+4LaYTxoqWuUjyz2STp9BTiBdJeCVAcrP
         ch69mtdHtNw01M33hUeokNqUyFRiFM71W83r4FtvpyQ+Ube7vdcvv/XS85x+6RzD0dj8
         Dt9JAWlp0mFUwe5Rxz/qDgGFFQscagztWH7DpHTZ1HrGtWRpWw77jfxwRqtyFkiHghRb
         6TYvEGx7p2CeC0SCvzwWMUSN+h/pBXeOIpk0rzm+ivKklsHDBQc3Mf13f0NO6FXbRJb3
         70OJ2PphO6NSVrr2515EpUV+75YZ38QrH0rzQelGi8EmCM39uRSeBnW8TQrdhd5DJNr7
         K91w==
X-Forwarded-Encrypted: i=1; AJvYcCX2dJ9fv19K8dH2goqXaqzMfpyTQo1wNpH0SG5YqPoHaLInpD1MCUbbdhSpCdiB5m/I40g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXSSW+qHNYA62QrNzdEn/e8HXK2JIZtY61j9wCa5OaXbc1ci8S
	OLg2jSK/TDZG7ryKw1go9DSgrOQJFDKgzrBa+tvVHMs58mvdaRvL3Tg2r7T6zCHAV+2aMMyqV+/
	rdzU9qHljKNjtkfAB3I4GoAkq+3OdEJnc7NxgZftG2wwYyWEQIA==
X-Gm-Gg: ASbGnctsF/KBvvjrE/IkBFDz1vaegnJuGzSv5c/g+q5DzeIbPxjfxb4DHSgZF3+izxc
	zwbgAZRVbdBi2AVocRyISKQZZt5qqE/jPGbNeVmIDNeVsmEzaLY7rR9d2g8O0Zv3bgmu9H7bE12
	WaBTy4G65jcgoCKV/I/l5oTbPNU8mtytHYzHCtE7OJ/BRRznvrMTSH7dWphzpl25caGlCN+GdgA
	lWAkcifuTFzNH1m4W6ZnL80mvH0uo8qNBzETRG2GlL5UwhVxpPgonlr+32EKWKA0IU6cC3zmQh1
	UwtRObrtrtsR8qfhkwDu0DbbmKRERfJ92LvCDz4AlX6/FfjA+9Mzye2slshfA6s=
X-Received: by 2002:a05:600c:35d6:b0:439:985b:17d6 with SMTP id 5b1f17b1804b1-43ab903603emr23927875e9.27.1740572947507;
        Wed, 26 Feb 2025 04:29:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEOqU6+YvkXlQ4vuTagbuCtwCjwmj0H5+Xta6YoRzeguoUafKp6W738/ohg4cf/c9smG6tt4g==
X-Received: by 2002:a05:600c:35d6:b0:439:985b:17d6 with SMTP id 5b1f17b1804b1-43ab903603emr23927655e9.27.1740572947018;
        Wed, 26 Feb 2025 04:29:07 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43aba5711dfsm19946945e9.27.2025.02.26.04.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 04:29:06 -0800 (PST)
Date: Wed, 26 Feb 2025 13:29:05 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, "Michael S . Tsirkin"
 <mst@redhat.com>, Shiju Jose <shiju.jose@huawei.com>,
 <qemu-arm@nongnu.org>, <qemu-devel@nongnu.org>, Philippe =?UTF-8?B?TWF0?=
 =?UTF-8?B?aGlldS1EYXVkw6k=?= <philmd@linaro.org>, Ani Sinha
 <anisinha@redhat.com>, Cleber Rosa <crosa@redhat.com>, Dongjiu Geng
 <gengdongjiu1@gmail.com>, Eduardo Habkost <eduardo@habkost.net>, Eric Blake
 <eblake@redhat.com>, John Snow <jsnow@redhat.com>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, "Markus Armbruster" <armbru@redhat.com>,
 Michael Roth <michael.roth@amd.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Shannon Zhao
 <shannon.zhaosl@gmail.com>, Yanan Wang <wangyanan55@huawei.com>, Zhao Liu
 <zhao1.liu@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v3 00/14] Change ghes to use HEST-based offsets and add
 support for error inject
Message-ID: <20250226132905.47aa50d2@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250226105628.7e60f952@foz.lan>
References: <cover.1738345063.git.mchehab+huawei@kernel.org>
	<20250203110934.000038d8@huawei.com>
	<20250203162236.7d5872ff@imammedo.users.ipa.redhat.com>
	<20250221073823.061a1039@foz.lan>
	<20250221102127.000059e6@huawei.com>
	<20250225110115.6090e416@imammedo.users.ipa.redhat.com>
	<20250226105628.7e60f952@foz.lan>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 26 Feb 2025 10:56:28 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> Em Tue, 25 Feb 2025 11:01:15 +0100
> Igor Mammedov <imammedo@redhat.com> escreveu:
> 
> > On Fri, 21 Feb 2025 10:21:27 +0000
> > Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:
> >   
> > > On Fri, 21 Feb 2025 07:38:23 +0100
> > > Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
> > >     
> > > > Em Mon, 3 Feb 2025 16:22:36 +0100
> > > > Igor Mammedov <imammedo@redhat.com> escreveu:
> > > >       
> > > > > On Mon, 3 Feb 2025 11:09:34 +0000
> > > > > Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:
> > > > >         
> > > > > > On Fri, 31 Jan 2025 18:42:41 +0100
> > > > > > Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
> > > > > >           
> > > > > > > Now that the ghes preparation patches were merged, let's add support
> > > > > > > for error injection.
> > > > > > > 
> > > > > > > On this series, the first 6 patches chang to the math used to calculate offsets at HEST
> > > > > > > table and hardware_error firmware file, together with its migration code. Migration tested
> > > > > > > with both latest QEMU released kernel and upstream, on both directions.
> > > > > > > 
> > > > > > > The next patches add a new QAPI to allow injecting GHESv2 errors, and a script using such QAPI
> > > > > > >    to inject ARM Processor Error records.
> > > > > > > 
> > > > > > > If I'm counting well, this is the 19th submission of my error inject patches.            
> > > > > > 
> > > > > > Looks good to me. All remaining trivial things are in the category
> > > > > > of things to consider only if you are doing another spin.  The code
> > > > > > ends up how I'd like it at the end of the series anyway, just
> > > > > > a question of the precise path to that state!          
> > > > > 
> > > > > if you look at series as a whole it's more or less fine (I guess you
> > > > > and me got used to it)
> > > > > 
> > > > > however if you take it patch by patch (as if you've never seen it)
> > > > > ordering is messed up (the same would apply to everyone after a while
> > > > > when it's forgotten)
> > > > > 
> > > > > So I'd strongly suggest to restructure the series (especially 2-6/14).
> > > > > re sum up my comments wrt ordering:
> > > > > 
> > > > > 0  add testcase for HEST table with current HEST as expected blob
> > > > >    (currently missing), so that we can be sure that we haven't messed
> > > > >    existing tables during refactoring.        
> > > 
> > > To potentially save time I think Igor is asking that before you do anything
> > > at all you plug the existing test hole which is that we don't test HEST
> > > at all.   Even after this series I think we don't test HEST.  You add
> > > a stub hest and exclusion but then in patch 12 the HEST stub is deleted whereas
> > > it should be replaced with the example data for the test.    
> > 
> > that's what I was saying.
> > HEST table should be in DSDT, but it's optional and one has to use
> > 'ras=on' option to enable that, which we aren't doing ATM.
> > So whatever changes are happening we aren't seeing them in tests
> > nor will we see any regression for the same reason.
> > 
> > While white listing tables before change should happen and then updating them
> > is the right thing to do, it's not sufficient since none of tests
> > run with 'ras' enabled, hence code is not actually executed.   
> 
> Ok. Well, again we're not modifying HEST table structure on this
> changeset. The only change affecting HEST is when the number of entries
> increased from 1 to 2.
> 
> Now, looking at bios-tables-test.c, if I got it right, I should be doing
> something similar to the enclosed patch, right?
> 
> If so, I have a couple of questions:
> 
> 1. from where should I get the HEST table? dumping the table from the
>    running VM?


> 
> 2. what values should I use to fill those variables:
> 
> 	int hest_offset = 40 /* HEST */;
> 	int hest_entry_size = 4;
you don't need to do that,
bios-tables-test will dump all ACPI tables for you automatically,
you only need to add or extend a test with ras=on option.

   1: 1st add empty table and whitelist it ("tests/data/acpi/aarch64/virt/HEST")
   2: enable ras in existing tescase

--- a/tests/qtest/bios-tables-test.c
+++ b/tests/qtest/bios-tables-test.c
@@ -2123,7 +2123,8 @@ static void test_acpi_aarch64_virt_tcg(void)
     data.smbios_cpu_max_speed = 2900;
     data.smbios_cpu_curr_speed = 2700;
     test_acpi_one("-cpu cortex-a57 "
-                  "-smbios type=4,max-speed=2900,current-speed=2700", &data);
+                  "-smbios type=4,max-speed=2900,current-speed=2700 "
+                  "-machine ras=on", &data);
     free_test_data(&data);
 }
     
  then with installed IASL run
    V=1 QTEST_QEMU_BINARY=./qemu-system-aarch64  ./tests/qtest/bios-tables-test
  to see diff

  3: rebuild tables and follow the rest of procedure to update expected blobs
     as described in comment at the top of (tests/qtest/bios-tables-test.c)

I'd recommend to add 3 patches as the beginning of the series,
that way we can be sure that if something changes unintentionally
it won't go unnoticed.

> 
> >   
> > > 
> > > That indeed doesn't address testing the error data storage which would be
> > > a different problem.    
> > 
> > I'd skip hardware_errors/CPER testing from QEMU unit tests.
> > That's basically requires functioning 'APEI driver' to test that.
> > 
> > Maybe we can use Ani's framework to parse HEST and all the way
> > towards CPER record(s) traversal, but that's certainly out of
> > scope of this series.
> > It could be done on top, but I won't insist even on that
> > since Mauro's out of tree error injection testing will
> > cover that using actual guest (which I assume he would
> > like to run periodically).  
> 
> Yeah, my plan is to periodically test it. I intend to setup somewhere
> a CI to test Kernel, QEMU and rasdaemon altogether.
> 
> Thanks,
> Mauro
> 
> ---
> 
> diff --git a/tests/qtest/bios-tables-test.c b/tests/qtest/bios-tables-test.c
> index 0a333ec43536..31e69d906db4 100644
> --- a/tests/qtest/bios-tables-test.c
> +++ b/tests/qtest/bios-tables-test.c
> @@ -210,6 +210,8 @@ static void test_acpi_fadt_table(test_data *data)
>      uint32_t val;
>      int dsdt_offset = 40 /* DSDT */;
>      int dsdt_entry_size = 4;
> +    int hest_offset = 40 /* HEST */;
> +    int hest_entry_size = 4;
>  
>      g_assert(compare_signature(&table, "FACP"));
>  
> @@ -242,6 +244,12 @@ static void test_acpi_fadt_table(test_data *data)
>      /* update checksum */
>      fadt_aml[9 /* Checksum */] = 0;
>      fadt_aml[9 /* Checksum */] -= acpi_calc_checksum(fadt_aml, fadt_len);
> +
> +
> +
> +    acpi_fetch_table(data->qts, &table.aml, &table.aml_len,
> +                     fadt_aml + hest_offset, hest_entry_size, "HEST", true);
> +    g_array_append_val(data->tables, table);
>  }
>  
>  static void dump_aml_files(test_data *data, bool rebuild)
> @@ -2411,7 +2419,7 @@ static void test_acpi_aarch64_virt_oem_fields(void)
>      };
>      char *args;
>  
> -    args = test_acpi_create_args(&data, "-cpu cortex-a57 "OEM_TEST_ARGS);
> +    args = test_acpi_create_args(&data, "-ras on -cpu cortex-a57 "OEM_TEST_ARGS);
>      data.qts = qtest_init(args);
>      test_acpi_load_tables(&data);
>      test_oem_fields(&data);
> 


