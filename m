Return-Path: <kvm+bounces-39271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CC92A45CF2
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 12:23:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D81007A651C
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 11:22:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EA9C21507A;
	Wed, 26 Feb 2025 11:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tJE2M1d5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C479F18C034;
	Wed, 26 Feb 2025 11:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740568991; cv=none; b=kOtnX9465zkce/gaGCQv3otRgovEJA6YEsWlPergXMr6zKDGyI/+Dhibru5xO8RVepxpkU+RNEb6j1s0f0SFQ4xEoqmoHWNOImis40S1cyPEoMZP6jBE8RPy29AnJpXU5gLmQs+F8D0GmbLfxGALD8CBzRLnIUepNXhHa+SwSr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740568991; c=relaxed/simple;
	bh=703UKprGGQpR0HDpKp0gIymTag7yafrb372oYXJMNek=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OSp4oP+e+98jGhwkwfOQYRJiNUCAI6K8iyPvuyvbGphb7nqmxog1SfvoGvdnr61lopeFghRh/jwZgsgv0NOE/tn6TwXe5C2r7OYbbEqAoit98ETIi3oZZjzG6+W2Telu6yHwLwWNqhDmFvey9CadOir+IJ46eBAhZaQ6U1aYtmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tJE2M1d5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9482C4CED6;
	Wed, 26 Feb 2025 11:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740568991;
	bh=703UKprGGQpR0HDpKp0gIymTag7yafrb372oYXJMNek=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tJE2M1d5GdnKvGF1N6IS1+Fqs1+GkWn5HTPUN6deuWEkUOsv0NgY2U39dE4euzCCO
	 j8dfBEa0jwmGlt0krOdObiwyBGBdDDmloHLuZ1HvGdVOCLwJB4Il3EglaBJlkPEQvJ
	 dFPMUGmqiCLkYv3962YSxSKGbCvxylhsOD4nIGk4gvMqVNsJtQy9Z02dWsbINWT5r1
	 t3HO5ktlT8unHlHTEwPZZ4CxaW4nCRv5P4hC3QbXPaFD3Gkg3E62jvLcFBtBKnGZCr
	 Xt+RS1egXezY0+IMHLnten5h19ick8VZbbP7nopvWMjHhulkfX560MYKIxn5IFw3l/
	 lvTm09yD7EQ4g==
Date: Wed, 26 Feb 2025 12:23:03 +0100
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>
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
Message-ID: <20250226122303.0131ce8b@foz.lan>
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

Em Wed, 26 Feb 2025 10:56:28 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> escreveu:

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

Thanks,
Mauro

As a reference, this is the HEST table before the patch series:

/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20240927 (64-bit version)
 * Copyright (c) 2000 - 2023 Intel Corporation
 * 
 * Disassembly of hest.dat
 *
 * ACPI Data Table [HEST]
 *
 * Format: [HexOffset DecimalOffset ByteLength]  FieldName : FieldValue (in hex)
 */

[000h 0000 004h]                   Signature : "HEST"    [Hardware Error Source Table]
[004h 0004 004h]                Table Length : 00000084
[008h 0008 001h]                    Revision : 01
[009h 0009 001h]                    Checksum : E0
[00Ah 0010 006h]                      Oem ID : "BOCHS "
[010h 0016 008h]                Oem Table ID : "BXPC    "
[018h 0024 004h]                Oem Revision : 00000001
[01Ch 0028 004h]             Asl Compiler ID : "BXPC"
[020h 0032 004h]       Asl Compiler Revision : 00000001

[024h 0036 004h]          Error Source Count : 00000001

[028h 0040 002h]               Subtable Type : 000A [Generic Hardware Error Source V2]
[02Ah 0042 002h]                   Source Id : 0000
[02Ch 0044 002h]           Related Source Id : FFFF
[02Eh 0046 001h]                    Reserved : 00
[02Fh 0047 001h]                     Enabled : 01
[030h 0048 004h]      Records To Preallocate : 00000001
[034h 0052 004h]     Max Sections Per Record : 00000001
[038h 0056 004h]         Max Raw Data Length : 00000400

[03Ch 0060 00Ch]        Error Status Address : [Generic Address Structure]
[03Ch 0060 001h]                    Space ID : 00 [SystemMemory]
[03Dh 0061 001h]                   Bit Width : 40
[03Eh 0062 001h]                  Bit Offset : 00
[03Fh 0063 001h]        Encoded Access Width : 04 [QWord Access:64]
[040h 0064 008h]                     Address : 0000000139E40000

[048h 0072 01Ch]                      Notify : [Hardware Error Notification Structure]
[048h 0072 001h]                 Notify Type : 08 [SEA]
[049h 0073 001h]               Notify Length : 1C
[04Ah 0074 002h]  Configuration Write Enable : 0000
[04Ch 0076 004h]                PollInterval : 00000000
[050h 0080 004h]                      Vector : 00000000
[054h 0084 004h]     Polling Threshold Value : 00000000
[058h 0088 004h]    Polling Threshold Window : 00000000
[05Ch 0092 004h]       Error Threshold Value : 00000000
[060h 0096 004h]      Error Threshold Window : 00000000

[064h 0100 004h]   Error Status Block Length : 00000400
[068h 0104 00Ch]           Read Ack Register : [Generic Address Structure]
[068h 0104 001h]                    Space ID : 00 [SystemMemory]
[069h 0105 001h]                   Bit Width : 40
[06Ah 0106 001h]                  Bit Offset : 00
[06Bh 0107 001h]        Encoded Access Width : 04 [QWord Access:64]
[06Ch 0108 008h]                     Address : 0000000139E40008

[074h 0116 008h]           Read Ack Preserve : FFFFFFFFFFFFFFFE
[07Ch 0124 008h]              Read Ack Write : 0000000000000001

Raw Table Data: Length 132 (0x84)

    0000: 48 45 53 54 84 00 00 00 01 E0 42 4F 43 48 53 20  // HEST......BOCHS 
    0010: 42 58 50 43 20 20 20 20 01 00 00 00 42 58 50 43  // BXPC    ....BXPC
    0020: 01 00 00 00 01 00 00 00 0A 00 00 00 FF FF 00 01  // ................
    0030: 01 00 00 00 01 00 00 00 00 04 00 00 00 40 00 04  // .............@..
    0040: 00 00 E4 39 01 00 00 00 08 1C 00 00 00 00 00 00  // ...9............
    0050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  // ................
    0060: 00 00 00 00 00 04 00 00 00 40 00 04 08 00 E4 39  // .........@.....9
    0070: 01 00 00 00 FE FF FF FF FF FF FF FF 01 00 00 00  // ................
    0080: 00 00 00 00  




