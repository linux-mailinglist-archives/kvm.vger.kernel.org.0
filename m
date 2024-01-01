Return-Path: <kvm+bounces-5412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87D08821580
	for <lists+kvm@lfdr.de>; Mon,  1 Jan 2024 23:13:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B87B5281BC1
	for <lists+kvm@lfdr.de>; Mon,  1 Jan 2024 22:13:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0FACFBF3;
	Mon,  1 Jan 2024 22:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=epfl.ch header.i=@epfl.ch header.b="O53yJF2O"
X-Original-To: kvm@vger.kernel.org
Received: from smtp4.epfl.ch (smtp4.epfl.ch [128.178.224.219])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D61DFBE2
	for <kvm@vger.kernel.org>; Mon,  1 Jan 2024 22:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epfl.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=epfl.ch
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=epfl.ch;
      s=epfl; t=1704146774;
      h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Content-Type;
      bh=PUOJe7vLfSenLa4KQWHHTKDyML/jdyg0YhQXNkcAzDg=;
      b=O53yJF2OvJICGcze/BAo7ImEoNMMbMNml0yNVcABamxfpfPFBL8RetnsFb4Drq8qy
        GRT0B5NQYr5phgVaN2at+oF4AM7RvN7T2LCYJfKigIrkm93Z7SBK9WJ/Lp5LpwT62
        RO/6IkNW84A6nt8YeY+I2QrgLpDew9VIB5gAVbhLQ=
Received: (qmail 48537 invoked by uid 107); 1 Jan 2024 22:06:14 -0000
Received: from ax-snat-224-178.epfl.ch (HELO ewa07.intranet.epfl.ch) (192.168.224.178) (TLS, ECDHE-RSA-AES256-GCM-SHA384 (P-256 curve) cipher)
  by mail.epfl.ch (AngelmatoPhylax SMTP proxy) with ESMTPS; Mon, 01 Jan 2024 23:06:14 +0100
X-EPFL-Auth: jqf4JdtrReEjLn5WJoQddHkQAVaqqFRVKPHkwKEwGcaifgRjDx8=
Received: from rs3labsrv2.iccluster.epfl.ch (10.90.46.62) by
 ewa07.intranet.epfl.ch (128.178.224.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 1 Jan 2024 23:06:13 +0100
From: Tao Lyu <tao.lyu@epfl.ch>
To: <akalita@cs.stonybrook.edu>
CC: <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: obtain the timestamp counter of physical/host machine inside the VMs.
Date: Mon, 1 Jan 2024 23:06:01 +0100
Message-ID: <20240101220601.2828996-1-tao.lyu@epfl.ch>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CAJGDS+Ez+NpVtaO5_NTdiwrnTTGFbevz+aDUyLMZk6ufie701Q@mail.gmail.com>
References: <CAJGDS+Ez+NpVtaO5_NTdiwrnTTGFbevz+aDUyLMZk6ufie701Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ewa07.intranet.epfl.ch (128.178.224.178) To
 ewa07.intranet.epfl.ch (128.178.224.178)

Hello Arnabjyoti, Sean, and everyone,

I'm having a similiar but slightly differnt issue about the rdtsc in KVM.

I want to obtain the timestamp counter of physical/host machine inside the VMs.

Acccording to the previous threads, I know I need to disable the offsetting, VM exit, and scaling.
I specify the correspoding parameters in the qemu arguments.
The booting command is listed below:

qemu-system-x86_64 -m 10240 -smp 4 -chardev socket,id=SOCKSYZ,server=on,nowait,host=localhost,port=3258 -mon chardev=SOCKSYZ,mode=control -display none -serial stdio -device virtio-rng-pci -enable-kvm -cpu host,migratable=off,tsc=on,rdtscp=on,vmx-tsc-offset=off,vmx-rdtsc-exit=off,tsc-scale=off,tsc-adjust=off,vmx-rdtscp-exit=off -netdev bridge,id=hn40 -device virtio-net,netdev=hn40,mac=e6:c8:ff:09:76:38 -hda XXX -kernel XXX -append "root=/dev/sda console=ttyS0"


But the rdtsc still returns the adjusted tsc.
The vmxcap script shows the TSC settings as below:
  
  Use TSC offsetting                       no
  RDTSC exiting                            no
  Enable RDTSCP                            no
  TSC scaling                              yes


I would really appreciate it if anyone can tell me whether and how I can get the tsc of physical machine insdie the VM.

Thanks a lot.

