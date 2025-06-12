Return-Path: <kvm+bounces-49315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8C28AD7CCC
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 22:59:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0A3E47AB2C8
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 20:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B36B2D877F;
	Thu, 12 Jun 2025 20:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="czO46aby"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1F22D877C
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 20:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749761965; cv=none; b=omj8N70wko7MVTXOAoqN5hh2hgNfH7e5cXw2uUf+C4YONKoSANEUFY7+mVC/Vsj4Lt5T5B3wXv5UW+9nyndL/sLEQ5qs3LPChj1zhDSqfqjX9YC/jyLh9SWe6HIwzWE7NkMHFXWReXk8EjHfeRBS3nL8x3K5zurgBUowuAAOqIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749761965; c=relaxed/simple;
	bh=QIKMICAsiKsGmtMJ/bablOHkKvN/nugmUX4pMQxqfZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KkvpFUO+h2wRvmGLoTAg7yjZ7ajVSZHveHL1ymD4PxgdZK42N/3BI0ckRTqijc8niInB7aN3Ze+5njJxg8MpE/4rB2KOb+DAio61Nw31ViHjY/ds0uj2BgnPqVNzL7bCXatrC19++nd3xJD49rimh5l4r5OEquTxr/IurXM3+wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=czO46aby; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749761948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RKA6rSz9QBF494ESPZ+f46MRT6LK6MH4hbX8WwUj0kM=;
	b=czO46abyO9RyPtEZY5L5/JL5b4czC9aJqk41/dXFa252Pq7lPleuko+lUXfYJR5Ch6+7pc
	/lqJ6mwSGzKvmXoF7BTi16LOvEspLrS0KEi1A2wK268LFs34Yu8U1wPKyPw4l9MufLZ5Sj
	hIGKzJZ1E54ghgFsx4dlfehagrw2Mes=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-117-hkMGk4vuPdesMfVQDJ7kBw-1; Thu,
 12 Jun 2025 16:59:01 -0400
X-MC-Unique: hkMGk4vuPdesMfVQDJ7kBw-1
X-Mimecast-MFC-AGG-ID: hkMGk4vuPdesMfVQDJ7kBw_1749761937
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 606DE1956089;
	Thu, 12 Jun 2025 20:58:57 +0000 (UTC)
Received: from jsnow-thinkpadp16vgen1.westford.csb (unknown [10.22.80.54])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0A9E51955F4A;
	Thu, 12 Jun 2025 20:58:26 +0000 (UTC)
From: John Snow <jsnow@redhat.com>
To: qemu-devel@nongnu.org
Cc: Joel Stanley <joel@jms.id.au>,
	Yi Liu <yi.l.liu@intel.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Helge Deller <deller@gmx.de>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Fabiano Rosas <farosas@suse.de>,
	Alexander Bulekov <alxndr@bu.edu>,
	Darren Kenny <darren.kenny@oracle.com>,
	Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Ed Maste <emaste@freebsd.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Warner Losh <imp@bsdimp.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Tyrone Ting <kfting@nuvoton.com>,
	Eric Blake <eblake@redhat.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Troy Lee <leetroy@gmail.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
	Michael Roth <michael.roth@amd.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Ani Sinha <anisinha@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	Steven Lee <steven_lee@aspeedtech.com>,
	Brian Cain <brian.cain@oss.qualcomm.com>,
	Li-Wen Hsu <lwhsu@freebsd.org>,
	Jamin Lin <jamin_lin@aspeedtech.com>,
	qemu-s390x@nongnu.org,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	qemu-block@nongnu.org,
	Bernhard Beschow <shentey@gmail.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	Maksim Davydov <davydov-max@yandex-team.ru>,
	Niek Linnenbank <nieklinnenbank@gmail.com>,
	=?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Paul Durrant <paul@xen.org>,
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
	Jagannathan Raman <jag.raman@oracle.com>,
	Igor Mitsyanko <i.mitsyanko@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Anton Johansson <anjo@rev.ng>,
	Peter Maydell <peter.maydell@linaro.org>,
	Cleber Rosa <crosa@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	qemu-arm@nongnu.org,
	Hao Wu <wuhaotsh@google.com>,
	Mads Ynddal <mads@ynddal.dk>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	qemu-riscv@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Alessandro Di Federico <ale@rev.ng>,
	Thomas Huth <thuth@redhat.com>,
	Antony Pavlov <antonynpavlov@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Qiuhao Li <Qiuhao.Li@outlook.com>,
	Hyman Huang <yong.huang@smartx.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	qemu-rust@nongnu.org,
	Bandan Das <bsd@redhat.com>,
	Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Fam Zheng <fam@euphon.net>,
	Jia Liu <proljc@gmail.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Alistair Francis <alistair@alistair23.me>,
	Subbaraya Sundeep <sundeep.lkml@gmail.com>,
	Kyle Evans <kevans@freebsd.org>,
	Song Gao <gaosong@loongson.cn>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Peter Xu <peterx@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Radoslaw Biernacki <rad@semihalf.com>,
	Beniamino Galvani <b.galvani@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Ahmed Karaman <ahmedkhaledkaraman@gmail.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>
Subject: [PATCH v2 06/12] python: upgrade to python3.9+ syntax
Date: Thu, 12 Jun 2025 16:54:44 -0400
Message-ID: <20250612205451.1177751-7-jsnow@redhat.com>
In-Reply-To: <20250612205451.1177751-1-jsnow@redhat.com>
References: <20250612205451.1177751-1-jsnow@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

This patch is fully automated, using pymagic, isort and autoflake.

Create a script named pymagic.sh:

=========================

pyupgrade --exit-zero-even-if-changed --keep-percent-format \
          --py39-plus "$@"

autoflake -i "$@"

isort --settings-file python/setup.cfg \
      -p compat -p qapidoc_legacy -p iotests -o qemu "$@"
=========================

Then, from qemu.git root:

> find . -type f -name '*.py' | xargs pymagic
> git grep --name-only "#!/usr/bin/env python" | xargs pymagic

This changes a lot of old Pythonisms, but in particular it upgrades the
old Python type hint paradigm to the new 3.9+ paradigm wherein you no
longer need to import List, Dict, Tuple, Set, etc from the Typing module
and instead directly subscript the built-in types list, dict, tuple,
set, etc. The old-style annotations are deprecated as of 3.9 and are
eligible for removal starting in Python 3.14, though the exact date of
their removal is not yet known.

pyupgrade updates the imports and type hint paradigms (as well as
updating other old 'isms, such as removing the unicode string
prefix). autoflake in turn then removes any unused import statements,
possibly left behind by pyupgrade. Lastly, isort fixes the import order
and formatting to the standard we use in qemu.git/python and
scripts/qapi in particular.

Signed-off-by: John Snow <jsnow@redhat.com>
---
 docs/conf.py                                  |  13 +-
 docs/sphinx/compat.py                         |   4 +-
 docs/sphinx/dbusdoc.py                        |  28 +-
 docs/sphinx/dbusdomain.py                     |  39 +--
 docs/sphinx/dbusparser.py                     |   4 +-
 docs/sphinx/depfile.py                        |  11 +-
 docs/sphinx/fakedbusdoc.py                    |   5 +-
 docs/sphinx/hxtool.py                         |   7 +-
 docs/sphinx/kerneldoc.py                      |   8 +-
 docs/sphinx/qapi_domain.py                    |  81 +++---
 docs/sphinx/qapidoc.py                        |  29 +-
 docs/sphinx/qapidoc_legacy.py                 |   1 -
 docs/sphinx/qmp_lexer.py                      |   7 +-
 .gitlab-ci.d/check-dco.py                     |   9 +-
 .gitlab-ci.d/check-patch.py                   |   7 +-
 .gitlab-ci.d/check-units.py                   |   8 +-
 python/qemu/machine/console_socket.py         |   2 +-
 python/qemu/machine/machine.py                |  34 +--
 python/qemu/machine/qtest.py                  |  13 +-
 python/qemu/qmp/events.py                     |  25 +-
 python/qemu/qmp/legacy.py                     |  15 +-
 python/qemu/qmp/message.py                    |  16 +-
 python/qemu/qmp/models.py                     |  11 +-
 python/qemu/qmp/protocol.py                   |  11 +-
 python/qemu/qmp/qmp_client.py                 |  14 +-
 python/qemu/qmp/qmp_shell.py                  |  15 +-
 python/qemu/qmp/qmp_tui.py                    |  21 +-
 python/qemu/utils/accel.py                    |   6 +-
 python/qemu/utils/qemu_ga_client.py           |  13 +-
 python/qemu/utils/qom_common.py               |  15 +-
 python/qemu/utils/qom_fuse.py                 |  13 +-
 python/scripts/mkvenv.py                      |  25 +-
 python/tests/protocol.py                      |   1 -
 roms/edk2-build.py                            |  17 +-
 scripts/analyse-9p-simpletrace.py             |   2 +
 scripts/analyse-locks-simpletrace.py          |   5 +-
 scripts/analyze-migration.py                  |  48 ++--
 scripts/block-coroutine-wrapper.py            |   4 +-
 scripts/check_sparse.py                       |   9 +-
 scripts/ci/gitlab-pipeline-status             |   4 +-
 .../codeconverter/codeconverter/patching.py   |  71 +++--
 .../codeconverter/codeconverter/qom_macros.py |  15 +-
 .../codeconverter/qom_type_info.py            |  10 +-
 .../codeconverter/codeconverter/regexps.py    |   5 +-
 .../codeconverter/test_patching.py            |   9 +-
 .../codeconverter/test_regexps.py             |   3 +-
 scripts/codeconverter/codeconverter/utils.py  |   5 +-
 scripts/codeconverter/converter.py            |  16 +-
 scripts/compare-machine-types.py              |  49 ++--
 scripts/coverage/compare_gcov_json.py         |   7 +-
 scripts/cpu-x86-uarch-abi.py                  |   4 +-
 scripts/decodetree.py                         |  12 +-
 scripts/device-crash-test                     |  18 +-
 scripts/dump-guest-memory.py                  |   5 +-
 scripts/feature_to_c.py                       |   5 +-
 scripts/kvm/kvm_flightrecorder                |   7 +-
 scripts/kvm/vmxcap                            |   6 +-
 scripts/meson-buildoptions.py                 |   3 +-
 scripts/minikconf.py                          |  13 +-
 scripts/modinfo-collect.py                    |   7 +-
 scripts/modinfo-generate.py                   |   4 +-
 scripts/modules/module_block.py               |   5 +-
 scripts/mtest2make.py                         |   8 +-
 scripts/oss-fuzz/minimize_qtest_trace.py      |  18 +-
 scripts/oss-fuzz/output_reproducer.py         |  18 +-
 .../oss-fuzz/reorder_fuzzer_qtest_trace.py    |   6 +-
 scripts/performance/dissect.py                |   2 +-
 scripts/performance/topN_callgrind.py         |   2 +-
 scripts/performance/topN_perf.py              |   2 +-
 scripts/probe-gdb-support.py                  |   4 +-
 scripts/python_qmp_updater.py                 |   1 +
 scripts/qapi-gen.py                           |   1 +
 scripts/qapi/commands.py                      |  13 +-
 scripts/qapi/common.py                        |  39 ++-
 scripts/qapi/error.py                         |   1 -
 scripts/qapi/events.py                        |   8 +-
 scripts/qapi/expr.py                          |  21 +-
 scripts/qapi/features.py                      |   2 +-
 scripts/qapi/gen.py                           |  14 +-
 scripts/qapi/introspect.py                    |  42 ++-
 scripts/qapi/parser.py                        |  44 ++-
 scripts/qapi/schema.py                        | 271 +++++++++---------
 scripts/qapi/source.py                        |  10 +-
 scripts/qapi/types.py                         |  20 +-
 scripts/qapi/visit.py                         |  14 +-
 scripts/qcow2-to-stdout.py                    |   8 +-
 scripts/qemu-gdb.py                           |  13 +-
 scripts/qemu-plugin-symbols.py                |   4 +-
 scripts/qemu-stamp.py                         |   1 +
 scripts/qemu-trace-stap                       |   1 -
 scripts/qemugdb/aio.py                        |   1 +
 scripts/qemugdb/coroutine.py                  |   1 +
 scripts/qemugdb/mtree.py                      |   1 +
 scripts/qemugdb/tcg.py                        |   2 +-
 scripts/qemugdb/timers.py                     |   2 +-
 scripts/qmp/qemu-ga-client                    |   1 +
 scripts/qmp/qmp                               |   1 +
 scripts/qmp/qmp-shell                         |   1 +
 scripts/qmp/qmp-shell-wrap                    |   1 +
 scripts/qmp/qom-fuse                          |   1 +
 scripts/qmp/qom-get                           |   1 +
 scripts/qmp/qom-list                          |   1 +
 scripts/qmp/qom-set                           |   1 +
 scripts/qmp/qom-tree                          |   1 +
 scripts/qom-cast-macro-clean-cocci-gen.py     |   3 +-
 scripts/render_block_graph.py                 |  28 +-
 scripts/replay-dump.py                        |  10 +-
 scripts/rust/rustc_args.py                    |  10 +-
 scripts/shaderinclude.py                      |   4 +-
 scripts/signrom.py                            |   3 +-
 scripts/simplebench/bench-backup.py           |   9 +-
 scripts/simplebench/bench-example.py          |   4 +-
 scripts/simplebench/bench_block_job.py        |   9 +-
 scripts/simplebench/bench_prealloc.py         |  10 +-
 scripts/simplebench/bench_write_req.py        |   5 +-
 scripts/simplebench/img_bench_templater.py    |  10 +-
 scripts/simplebench/results_to_text.py        |   4 +-
 scripts/simplebench/simplebench.py            |   2 +-
 scripts/simplebench/table_templater.py        |   4 +-
 scripts/simpletrace.py                        |  16 +-
 scripts/symlink-install-tree.py               |   3 +-
 scripts/tracetool.py                          |   5 +-
 scripts/tracetool/__init__.py                 |  11 +-
 scripts/tracetool/backend/__init__.py         |   2 -
 scripts/tracetool/backend/dtrace.py           |   2 -
 scripts/tracetool/backend/ftrace.py           |   2 -
 scripts/tracetool/backend/log.py              |   2 -
 scripts/tracetool/backend/simple.py           |   2 -
 scripts/tracetool/backend/syslog.py           |   2 -
 scripts/tracetool/backend/ust.py              |   2 -
 scripts/tracetool/format/__init__.py          |   2 -
 scripts/tracetool/format/c.py                 |   2 -
 scripts/tracetool/format/d.py                 |   5 +-
 scripts/tracetool/format/h.py                 |   2 -
 scripts/tracetool/format/log_stap.py          |   3 +-
 scripts/tracetool/format/simpletrace_stap.py  |   3 +-
 scripts/tracetool/format/stap.py              |   2 -
 scripts/tracetool/format/ust_events_c.py      |   2 -
 scripts/tracetool/format/ust_events_h.py      |   2 -
 scripts/u2f-setup-gen.py                      |  15 +-
 scripts/undefsym.py                           |   3 +-
 scripts/userfaultfd-wrlat.py                  |   8 +-
 scripts/vmstate-static-checker.py             |   1 +
 scripts/xml-preprocess-test.py                |   3 +-
 scripts/xml-preprocess.py                     |   4 +-
 target/hexagon/gen_analyze_funcs.py           |   3 -
 target/hexagon/gen_decodetree.py              |   9 +-
 target/hexagon/gen_helper_funcs.py            |   3 -
 target/hexagon/gen_helper_protos.py           |   4 +-
 target/hexagon/gen_idef_parser_funcs.py       |   4 -
 target/hexagon/gen_op_attribs.py              |   6 +-
 target/hexagon/gen_opcodes_def.py             |   6 +-
 target/hexagon/gen_printinsn.py               |   5 +-
 target/hexagon/gen_tcg_func_table.py          |   6 +-
 target/hexagon/gen_tcg_funcs.py               |   3 -
 target/hexagon/gen_trans_funcs.py             |   8 +-
 target/hexagon/hex_common.py                  |  15 +-
 tests/docker/docker.py                        |  37 ++-
 tests/functional/aspeed.py                    |   4 +-
 tests/functional/qemu_test/__init__.py        |  30 +-
 tests/functional/qemu_test/archive.py         |   2 +-
 tests/functional/qemu_test/asset.py           |  10 +-
 tests/functional/qemu_test/decorators.py      |   1 +
 tests/functional/qemu_test/linuxkernel.py     |   5 +-
 tests/functional/qemu_test/ports.py           |   3 +-
 tests/functional/qemu_test/testcase.py        |   2 +-
 tests/functional/qemu_test/tuxruntest.py      |  12 +-
 tests/functional/qemu_test/uncompress.py      |   4 +-
 tests/functional/replay_kernel.py             |   7 +-
 tests/functional/reverse_debugging.py         |   5 +-
 .../functional/test_aarch64_aspeed_ast2700.py |   9 +-
 .../test_aarch64_aspeed_ast2700fc.py          |   9 +-
 tests/functional/test_aarch64_imx8mp_evk.py   |   4 +-
 tests/functional/test_aarch64_raspi3.py       |   2 +-
 tests/functional/test_aarch64_raspi4.py       |   7 +-
 tests/functional/test_aarch64_replay.py       |   4 +-
 .../functional/test_aarch64_reverse_debug.py  |   2 +-
 tests/functional/test_aarch64_rme_sbsaref.py  |   8 +-
 tests/functional/test_aarch64_rme_virt.py     |  11 +-
 tests/functional/test_aarch64_sbsaref.py      |   9 +-
 .../functional/test_aarch64_sbsaref_alpine.py |   8 +-
 .../test_aarch64_sbsaref_freebsd.py           |   8 +-
 tests/functional/test_aarch64_smmu.py         |   8 +-
 tests/functional/test_aarch64_tcg_plugins.py  |   4 +-
 tests/functional/test_aarch64_tuxrun.py       |   1 +
 tests/functional/test_aarch64_virt.py         |  11 +-
 tests/functional/test_aarch64_virt_gpu.py     |   7 +-
 tests/functional/test_aarch64_xlnx_versal.py  |   3 +-
 tests/functional/test_acpi_bits.py            |  21 +-
 tests/functional/test_alpha_clipper.py        |   2 +-
 tests/functional/test_arm_aspeed_ast1030.py   |   7 +-
 tests/functional/test_arm_aspeed_ast2500.py   |   2 +-
 tests/functional/test_arm_aspeed_ast2600.py   |  11 +-
 tests/functional/test_arm_aspeed_bletchley.py |   2 +-
 tests/functional/test_arm_aspeed_palmetto.py  |   2 +-
 tests/functional/test_arm_aspeed_rainier.py   |   3 +-
 tests/functional/test_arm_aspeed_romulus.py   |   2 +-
 .../functional/test_arm_aspeed_witherspoon.py |   2 +-
 tests/functional/test_arm_bflt.py             |   8 +-
 tests/functional/test_arm_bpim2u.py           |  10 +-
 tests/functional/test_arm_canona1100.py       |   3 +-
 tests/functional/test_arm_collie.py           |   2 +-
 tests/functional/test_arm_cubieboard.py       |  10 +-
 tests/functional/test_arm_emcraft_sf2.py      |   7 +-
 tests/functional/test_arm_integratorcp.py     |  12 +-
 tests/functional/test_arm_microbit.py         |   8 +-
 tests/functional/test_arm_orangepi.py         |  11 +-
 tests/functional/test_arm_quanta_gsj.py       |   9 +-
 tests/functional/test_arm_raspi2.py           |   7 +-
 tests/functional/test_arm_smdkc210.py         |   2 +-
 tests/functional/test_arm_stellaris.py        |   8 +-
 tests/functional/test_arm_sx1.py              |   2 +-
 tests/functional/test_arm_tuxrun.py           |   1 +
 tests/functional/test_arm_vexpress.py         |   2 +-
 tests/functional/test_arm_virt.py             |   3 +-
 tests/functional/test_avr_mega2560.py         |   2 +-
 tests/functional/test_avr_uno.py              |   2 +-
 tests/functional/test_cpu_queries.py          |   1 +
 tests/functional/test_empty_cpu_model.py      |   1 +
 tests/functional/test_hppa_seabios.py         |   4 +-
 tests/functional/test_i386_tuxrun.py          |   1 +
 tests/functional/test_intel_iommu.py          |   6 +-
 tests/functional/test_linux_initrd.py         |   2 +-
 tests/functional/test_loongarch64_virt.py     |  10 +-
 tests/functional/test_m68k_mcf5208evb.py      |   2 +-
 tests/functional/test_m68k_nextcube.py        |   8 +-
 tests/functional/test_m68k_q800.py            |   3 +-
 tests/functional/test_m68k_tuxrun.py          |   1 +
 tests/functional/test_mem_addr_space.py       |   4 +-
 tests/functional/test_memlock.py              |   9 +-
 .../functional/test_microblaze_s3adsp1800.py  |   9 +-
 tests/functional/test_mips64_malta.py         |   2 +-
 tests/functional/test_mips64_tuxrun.py        |   1 +
 tests/functional/test_mips64el_fuloong2e.py   |  11 +-
 tests/functional/test_mips64el_loongson3v.py  |   8 +-
 tests/functional/test_mips64el_malta.py       |  17 +-
 tests/functional/test_mips64el_tuxrun.py      |   1 +
 tests/functional/test_mips_malta.py           |   8 +-
 tests/functional/test_mips_tuxrun.py          |   1 +
 tests/functional/test_mipsel_malta.py         |  11 +-
 tests/functional/test_mipsel_tuxrun.py        |   1 +
 tests/functional/test_multiprocess.py         |  10 +-
 tests/functional/test_netdev_ethtool.py       |   5 +-
 tests/functional/test_or1k_sim.py             |   2 +-
 tests/functional/test_pc_cpu_hotplug_props.py |   1 +
 tests/functional/test_ppc64_e500.py           |   7 +-
 tests/functional/test_ppc64_hv.py             |  16 +-
 tests/functional/test_ppc64_mac99.py          |   8 +-
 tests/functional/test_ppc64_powernv.py        |   4 +-
 tests/functional/test_ppc64_pseries.py        |   4 +-
 tests/functional/test_ppc64_reverse_debug.py  |   2 +-
 tests/functional/test_ppc64_tuxrun.py         |   3 +-
 tests/functional/test_ppc_40p.py              |  10 +-
 tests/functional/test_ppc_74xx.py             |   4 +-
 tests/functional/test_ppc_amiga.py            |   3 +-
 tests/functional/test_ppc_bamboo.py           |   9 +-
 tests/functional/test_ppc_mac.py              |   2 +-
 tests/functional/test_ppc_mpc8544ds.py        |   3 +-
 tests/functional/test_ppc_sam460ex.py         |   7 +-
 tests/functional/test_ppc_tuxrun.py           |   1 +
 tests/functional/test_ppc_virtex_ml507.py     |   3 +-
 tests/functional/test_riscv32_tuxrun.py       |   1 +
 tests/functional/test_riscv64_tuxrun.py       |   1 +
 tests/functional/test_riscv_opensbi.py        |   4 +-
 tests/functional/test_rx_gdbsim.py            |  10 +-
 tests/functional/test_s390x_ccw_virtio.py     |   9 +-
 tests/functional/test_s390x_topology.py       |  11 +-
 tests/functional/test_s390x_tuxrun.py         |   1 +
 tests/functional/test_sh4_r2d.py              |   2 +-
 tests/functional/test_sh4_tuxrun.py           |   1 +
 tests/functional/test_sh4eb_r2d.py            |   7 +-
 tests/functional/test_sparc64_sun4u.py        |   3 +-
 tests/functional/test_sparc64_tuxrun.py       |   1 +
 tests/functional/test_sparc_sun4m.py          |   2 +-
 tests/functional/test_virtio_balloon.py       |  10 +-
 tests/functional/test_virtio_gpu.py           |  14 +-
 tests/functional/test_virtio_version.py       |   1 +
 tests/functional/test_x86_64_hotplug_blk.py   |   6 +-
 tests/functional/test_x86_64_hotplug_cpu.py   |   6 +-
 tests/functional/test_x86_64_kvm_xen.py       |   8 +-
 tests/functional/test_x86_64_replay.py        |   4 +-
 tests/functional/test_x86_64_reverse_debug.py |   2 +-
 tests/functional/test_x86_64_tuxrun.py        |   1 +
 .../functional/test_x86_cpu_model_versions.py |  13 +-
 tests/functional/test_xtensa_lx60.py          |   2 +-
 tests/guest-debug/run-test.py                 |   9 +-
 tests/guest-debug/test_gdbstub.py             |  15 +-
 tests/image-fuzzer/qcow2/fuzz.py              |   3 +-
 tests/image-fuzzer/qcow2/layout.py            |  32 ++-
 tests/image-fuzzer/runner.py                  |  19 +-
 tests/lcitool/refresh                         |   6 +-
 tests/migration-stress/guestperf-batch.py     |   1 +
 tests/migration-stress/guestperf-plot.py      |   1 +
 tests/migration-stress/guestperf.py           |   1 +
 .../migration-stress/guestperf/comparison.py  |   3 +-
 tests/migration-stress/guestperf/engine.py    |   8 +-
 tests/migration-stress/guestperf/hardware.py  |   2 +-
 tests/migration-stress/guestperf/plot.py      |   4 +-
 tests/migration-stress/guestperf/progress.py  |   4 +-
 tests/migration-stress/guestperf/report.py    |   9 +-
 tests/migration-stress/guestperf/scenario.py  |   2 +-
 tests/migration-stress/guestperf/shell.py     |  18 +-
 tests/migration-stress/guestperf/timings.py   |   4 +-
 tests/qapi-schema/test-qapi.py                |   2 +-
 tests/qemu-iotests/030                        |   6 +-
 tests/qemu-iotests/040                        |   6 +-
 tests/qemu-iotests/041                        |   7 +-
 tests/qemu-iotests/044                        |  11 +-
 tests/qemu-iotests/045                        |  10 +-
 tests/qemu-iotests/055                        |   4 +-
 tests/qemu-iotests/056                        |   6 +-
 tests/qemu-iotests/057                        |   5 +-
 tests/qemu-iotests/065                        |  10 +-
 tests/qemu-iotests/093                        |   9 +-
 tests/qemu-iotests/096                        |   4 +-
 tests/qemu-iotests/118                        |   4 +-
 tests/qemu-iotests/124                        |   8 +-
 tests/qemu-iotests/129                        |   2 +
 tests/qemu-iotests/132                        |   3 +-
 tests/qemu-iotests/136                        |   4 +-
 tests/qemu-iotests/139                        |   3 +-
 tests/qemu-iotests/141                        |   1 +
 tests/qemu-iotests/147                        |  13 +-
 tests/qemu-iotests/148                        |   2 +
 tests/qemu-iotests/149                        |   7 +-
 tests/qemu-iotests/151                        |   6 +-
 tests/qemu-iotests/152                        |   2 +
 tests/qemu-iotests/155                        |   2 +
 tests/qemu-iotests/163                        |  11 +-
 tests/qemu-iotests/165                        |   3 +-
 tests/qemu-iotests/194                        |   7 +-
 tests/qemu-iotests/196                        |   2 +
 tests/qemu-iotests/202                        |   1 +
 tests/qemu-iotests/203                        |   1 +
 tests/qemu-iotests/205                        |  11 +-
 tests/qemu-iotests/206                        |   1 +
 tests/qemu-iotests/207                        |   6 +-
 tests/qemu-iotests/208                        |   1 +
 tests/qemu-iotests/209                        |  11 +-
 tests/qemu-iotests/210                        |   1 +
 tests/qemu-iotests/211                        |   1 +
 tests/qemu-iotests/212                        |   1 +
 tests/qemu-iotests/213                        |   1 +
 tests/qemu-iotests/216                        |   1 +
 tests/qemu-iotests/218                        |   1 +
 tests/qemu-iotests/219                        |   1 +
 tests/qemu-iotests/224                        |  13 +-
 tests/qemu-iotests/228                        |  11 +-
 tests/qemu-iotests/234                        |   4 +-
 tests/qemu-iotests/235                        |  14 +-
 tests/qemu-iotests/236                        |   1 +
 tests/qemu-iotests/237                        |   2 +
 tests/qemu-iotests/238                        |   3 +-
 tests/qemu-iotests/240                        |   2 +-
 tests/qemu-iotests/242                        |  23 +-
 tests/qemu-iotests/245                        |   1 +
 tests/qemu-iotests/246                        |   1 +
 tests/qemu-iotests/248                        |  12 +-
 tests/qemu-iotests/254                        |   3 +-
 tests/qemu-iotests/255                        |   1 +
 tests/qemu-iotests/256                        |   4 +-
 tests/qemu-iotests/257                        |  28 +-
 tests/qemu-iotests/258                        |  10 +-
 tests/qemu-iotests/260                        |   8 +-
 tests/qemu-iotests/262                        |   4 +-
 tests/qemu-iotests/264                        |   7 +-
 tests/qemu-iotests/274                        |   1 +
 tests/qemu-iotests/277                        |  10 +-
 tests/qemu-iotests/280                        |   2 +-
 tests/qemu-iotests/281                        |   4 +-
 tests/qemu-iotests/283                        |   1 +
 tests/qemu-iotests/295                        |   6 +-
 tests/qemu-iotests/296                        |   7 +-
 tests/qemu-iotests/297                        |   8 +-
 tests/qemu-iotests/298                        |   2 +
 tests/qemu-iotests/299                        |   1 +
 tests/qemu-iotests/300                        |  10 +-
 tests/qemu-iotests/302                        |   4 +-
 tests/qemu-iotests/303                        |  13 +-
 tests/qemu-iotests/304                        |   3 +-
 tests/qemu-iotests/307                        |   2 +-
 tests/qemu-iotests/310                        |   1 +
 tests/qemu-iotests/check                      |   7 +-
 tests/qemu-iotests/fat16.py                   |  11 +-
 tests/qemu-iotests/findtests.py               |  19 +-
 tests/qemu-iotests/iotests.py                 |  66 +++--
 tests/qemu-iotests/linters.py                 |   9 +-
 tests/qemu-iotests/nbd-fault-injector.py      |  13 +-
 tests/qemu-iotests/qcow2.py                   |   5 +-
 tests/qemu-iotests/qcow2_format.py            |  14 +-
 tests/qemu-iotests/qed.py                     |  10 +-
 tests/qemu-iotests/testenv.py                 |  25 +-
 tests/qemu-iotests/testrunner.py              |  32 +--
 tests/qemu-iotests/tests/block-status-cache   |   1 +
 .../tests/export-incoming-iothread            |   1 +
 .../qemu-iotests/tests/graph-changes-while-io |  11 +-
 tests/qemu-iotests/tests/image-fleecing       |   1 +
 tests/qemu-iotests/tests/inactive-node-nbd    |   8 +-
 .../tests/iothreads-commit-active             |   2 +
 tests/qemu-iotests/tests/iothreads-create     |   2 +
 tests/qemu-iotests/tests/iothreads-nbd-export |   3 +
 tests/qemu-iotests/tests/iothreads-stream     |   2 +
 tests/qemu-iotests/tests/luks-detached-header |   5 +-
 .../tests/migrate-bitmaps-postcopy-test       |  10 +-
 tests/qemu-iotests/tests/migrate-bitmaps-test |   2 +-
 .../qemu-iotests/tests/migrate-during-backup  |   1 +
 .../tests/mirror-change-copy-mode             |   3 +-
 .../tests/mirror-ready-cancel-error           |   1 +
 tests/qemu-iotests/tests/nbd-multiconn        |   2 +-
 .../qemu-iotests/tests/nbd-reconnect-on-open  |  11 +-
 .../qemu-iotests/tests/parallels-read-bitmap  |   8 +-
 tests/qemu-iotests/tests/qsd-migrate          |   2 +-
 .../tests/remove-bitmap-from-backing          |   8 +-
 tests/qemu-iotests/tests/reopen-file          |   3 +-
 .../qemu-iotests/tests/stream-error-on-reset  |   8 +-
 .../tests/stream-unaligned-prefetch           |  13 +-
 .../qemu-iotests/tests/stream-under-throttle  |   4 +-
 tests/qemu-iotests/tests/vvfat                |   7 +-
 tests/tcg/aarch64/gdbstub/test-mte.py         |   2 +-
 tests/tcg/aarch64/gdbstub/test-sve-ioctl.py   |   4 +-
 tests/tcg/aarch64/gdbstub/test-sve.py         |   2 +-
 tests/tcg/i386/test-avx.py                    |  11 +-
 tests/tcg/i386/test-mmx.py                    |   9 +-
 tests/tcg/multiarch/gdbstub/catch-syscalls.py |   6 +-
 .../gdbstub/follow-fork-mode-child.py         |   4 +-
 .../gdbstub/follow-fork-mode-parent.py        |   2 +-
 tests/tcg/multiarch/gdbstub/interrupt.py      |   1 -
 tests/tcg/multiarch/gdbstub/late-attach.py    |   4 +-
 tests/tcg/multiarch/gdbstub/memory.py         |   2 -
 tests/tcg/multiarch/gdbstub/prot-none.py      |   5 +-
 tests/tcg/multiarch/gdbstub/registers.py      |   3 +-
 tests/tcg/multiarch/gdbstub/sha1.py           |   1 -
 .../multiarch/gdbstub/test-proc-mappings.py   |   1 -
 .../multiarch/gdbstub/test-qxfer-auxv-read.py |   1 -
 .../gdbstub/test-qxfer-siginfo-read.py        |   2 +-
 .../gdbstub/test-thread-breakpoint.py         |   1 -
 .../system/validate-memory-counts.py          |   7 +-
 tests/tcg/s390x/gdbstub/test-signals-s390x.py |   2 -
 tests/tcg/s390x/gdbstub/test-svc.py           |   1 -
 tests/vm/aarch64vm.py                         |  16 +-
 tests/vm/basevm.py                            |  37 +--
 tests/vm/centos.aarch64                       |  11 +-
 tests/vm/freebsd                              |   7 +-
 tests/vm/haiku.x86_64                         |   7 +-
 tests/vm/netbsd                               |   5 +-
 tests/vm/openbsd                              |   5 +-
 tests/vm/ubuntu.aarch64                       |   6 +-
 tests/vm/ubuntuvm.py                          |   6 +-
 448 files changed, 1959 insertions(+), 1631 deletions(-)

diff --git a/docs/conf.py b/docs/conf.py
index f892a6e1da3..0a984ce4d96 100644
--- a/docs/conf.py
+++ b/docs/conf.py
@@ -1,4 +1,3 @@
-# -*- coding: utf-8 -*-
 #
 # QEMU documentation build configuration file, created by
 # sphinx-quickstart on Thu Jan 31 16:40:14 2019.
@@ -28,9 +27,11 @@
 
 import os
 import sys
+
 import sphinx
 from sphinx.errors import ConfigError
 
+
 # The per-manual conf.py will set qemu_docdir for a single-manual build;
 # otherwise set it here if this is an entire-manual-set build.
 # This is always the absolute path of the docs/ directory in the source tree.
@@ -93,9 +94,9 @@
 default_role = 'any'
 
 # General information about the project.
-project = u'QEMU'
-copyright = u'2025, The QEMU Project Developers'
-author = u'The QEMU Project Developers'
+project = 'QEMU'
+copyright = '2025, The QEMU Project Developers'
+author = 'The QEMU Project Developers'
 
 # The version info for the project you're documenting, acts as replacement for
 # |version| and |release|, also used in various other places throughout the
@@ -291,8 +292,8 @@
 # (source start file, target name, title,
 #  author, documentclass [howto, manual, or own class]).
 latex_documents = [
-    (master_doc, 'QEMU.tex', u'QEMU Documentation',
-     u'The QEMU Project Developers', 'manual'),
+    (master_doc, 'QEMU.tex', 'QEMU Documentation',
+     'The QEMU Project Developers', 'manual'),
 ]
 
 
diff --git a/docs/sphinx/compat.py b/docs/sphinx/compat.py
index 9cf7fe006e4..2a93687cb3e 100644
--- a/docs/sphinx/compat.py
+++ b/docs/sphinx/compat.py
@@ -8,13 +8,11 @@
     Any,
     Callable,
     Optional,
-    Type,
 )
 
 from docutils import nodes
 from docutils.nodes import Element, Node, Text
 from docutils.statemachine import StringList
-
 import sphinx
 from sphinx import addnodes, util
 from sphinx.directives import ObjectDescription
@@ -85,7 +83,7 @@ def _compat_make_xref(  # pylint: disable=unused-argument
     rolename: str,
     domain: str,
     target: str,
-    innernode: Type[TextlikeNode] = addnodes.literal_emphasis,
+    innernode: type[TextlikeNode] = addnodes.literal_emphasis,
     contnode: Optional[Node] = None,
     env: Optional[BuildEnvironment] = None,
     inliner: Any = None,
diff --git a/docs/sphinx/dbusdoc.py b/docs/sphinx/dbusdoc.py
index be284ed08fd..ba4ad4bceba 100644
--- a/docs/sphinx/dbusdoc.py
+++ b/docs/sphinx/dbusdoc.py
@@ -7,30 +7,16 @@
 # Author: Marc-André Lureau <marcandre.lureau@redhat.com>
 """dbus-doc is a Sphinx extension that provides documentation from D-Bus XML."""
 
-import os
-import re
-from typing import (
-    TYPE_CHECKING,
-    Any,
-    Callable,
-    Dict,
-    Iterator,
-    List,
-    Optional,
-    Sequence,
-    Set,
-    Tuple,
-    Type,
-    TypeVar,
-    Union,
-)
+from typing import Any
 
-import sphinx
+import dbusdomain
+from dbusparser import parse_dbus_xml
 from docutils import nodes
 from docutils.nodes import Element, Node
 from docutils.parsers.rst import Directive, directives
 from docutils.parsers.rst.states import RSTState
 from docutils.statemachine import StringList, ViewList
+import sphinx
 from sphinx.application import Sphinx
 from sphinx.errors import ExtensionError
 from sphinx.util import logging
@@ -38,8 +24,6 @@
 from sphinx.util.docutils import SphinxDirective, switch_source_input
 from sphinx.util.nodes import nested_parse_with_titles
 
-import dbusdomain
-from dbusparser import parse_dbus_xml
 
 logger = logging.getLogger(__name__)
 
@@ -116,7 +100,7 @@ def add_interface(self, iface):
         self.indent = self.indent[:-3]
 
 
-def parse_generated_content(state: RSTState, content: StringList) -> List[Node]:
+def parse_generated_content(state: RSTState, content: StringList) -> list[Node]:
     """Parse a generated content by Documenter."""
     with switch_source_input(state, content):
         node = nodes.paragraph()
@@ -157,7 +141,7 @@ def run(self):
         return result
 
 
-def setup(app: Sphinx) -> Dict[str, Any]:
+def setup(app: Sphinx) -> dict[str, Any]:
     """Register dbus-doc directive with Sphinx"""
     app.add_config_value("dbusdoc_srctree", None, "env")
     app.add_directive("dbus-doc", DBusDocDirective)
diff --git a/docs/sphinx/dbusdomain.py b/docs/sphinx/dbusdomain.py
index 9872fd5bf6a..755eca8cf80 100644
--- a/docs/sphinx/dbusdomain.py
+++ b/docs/sphinx/dbusdomain.py
@@ -6,15 +6,11 @@
 #
 # Author: Marc-André Lureau <marcandre.lureau@redhat.com>
 
+from collections.abc import Iterable, Iterator
 from typing import (
     Any,
-    Dict,
-    Iterable,
-    Iterator,
-    List,
     NamedTuple,
     Optional,
-    Tuple,
     cast,
 )
 
@@ -24,7 +20,12 @@
 from sphinx import addnodes
 from sphinx.addnodes import desc_signature, pending_xref
 from sphinx.directives import ObjectDescription
-from sphinx.domains import Domain, Index, IndexEntry, ObjType
+from sphinx.domains import (
+    Domain,
+    Index,
+    IndexEntry,
+    ObjType,
+)
 from sphinx.locale import _
 from sphinx.roles import XRefRole
 from sphinx.util import nodes as node_utils
@@ -87,7 +88,7 @@ def handle_signature(self, sig: str, signode: desc_signature) -> str:
         signode += addnodes.desc_name(sig, sig)
         return sig
 
-    def run(self) -> List[Node]:
+    def run(self) -> list[Node]:
         _, node = super().run()
         name = self.arguments[0]
         section = nodes.section(ids=[name + "-section"])
@@ -113,7 +114,7 @@ class DBusMethod(DBusMember):
         }
     )
 
-    doc_field_types: List[Field] = [
+    doc_field_types: list[Field] = [
         TypedField(
             "arg",
             label=_("Arguments"),
@@ -171,7 +172,7 @@ class DBusSignal(DBusMethod):
     Implementation of ``dbus:signal``.
     """
 
-    doc_field_types: List[Field] = [
+    doc_field_types: list[Field] = [
         TypedField(
             "arg",
             label=_("Arguments"),
@@ -203,7 +204,7 @@ class DBusProperty(DBusMember):
         }
     )
 
-    doc_field_types: List[Field] = []
+    doc_field_types: list[Field] = []
 
     def get_index_text(self, ifacename: str, name: str) -> str:
         return _("%s (%s property)") % (name, ifacename)
@@ -244,7 +245,7 @@ def handle_signature(self, sig: str, signode: desc_signature) -> str:
         signode += addnodes.desc_sig_keyword_type(ty, ty)
         return sig
 
-    def run(self) -> List[Node]:
+    def run(self) -> list[Node]:
         self.name = "dbus:member"
         return super().run()
 
@@ -281,10 +282,10 @@ class DBusIndex(Index):
 
     def generate(
         self, docnames: Iterable[str] = None
-    ) -> Tuple[List[Tuple[str, List[IndexEntry]]], bool]:
-        content: Dict[str, List[IndexEntry]] = {}
+    ) -> tuple[list[tuple[str, list[IndexEntry]]], bool]:
+        content: dict[str, list[IndexEntry]] = {}
         # list of prefixes to ignore
-        ignores: List[str] = self.domain.env.config["dbus_index_common_prefix"]
+        ignores: list[str] = self.domain.env.config["dbus_index_common_prefix"]
         ignores = sorted(ignores, key=len, reverse=True)
 
         ifaces = sorted(
@@ -329,7 +330,7 @@ class DBusDomain(Domain):
 
     name = "dbus"
     label = "D-Bus"
-    object_types: Dict[str, ObjType] = {
+    object_types: dict[str, ObjType] = {
         "interface": ObjType(_("interface"), "iface", "obj"),
         "method": ObjType(_("method"), "meth", "obj"),
         "signal": ObjType(_("signal"), "sig", "obj"),
@@ -347,7 +348,7 @@ class DBusDomain(Domain):
         "sig": DBusXRef(),
         "prop": DBusXRef(),
     }
-    initial_data: Dict[str, Dict[str, Tuple[Any]]] = {
+    initial_data: dict[str, dict[str, tuple[Any]]] = {
         "objects": {},  # fullname -> ObjectEntry
     }
     indices = [
@@ -355,7 +356,7 @@ class DBusDomain(Domain):
     ]
 
     @property
-    def objects(self) -> Dict[str, ObjectEntry]:
+    def objects(self) -> dict[str, ObjectEntry]:
         return self.data.setdefault("objects", {})  # fullname -> ObjectEntry
 
     def note_object(
@@ -368,7 +369,7 @@ def clear_doc(self, docname: str) -> None:
             if obj.docname == docname:
                 del self.objects[fullname]
 
-    def find_obj(self, typ: str, name: str) -> Optional[Tuple[str, ObjectEntry]]:
+    def find_obj(self, typ: str, name: str) -> Optional[tuple[str, ObjectEntry]]:
         # skip parens
         if name[-2:] == "()":
             name = name[:-2]
@@ -396,7 +397,7 @@ def resolve_xref(
                 builder, fromdocname, objdef.docname, objdef.node_id, contnode
             )
 
-    def get_objects(self) -> Iterator[Tuple[str, str, str, str, str, int]]:
+    def get_objects(self) -> Iterator[tuple[str, str, str, str, str, int]]:
         for refname, obj in self.objects.items():
             yield (refname, refname, obj.objtype, obj.docname, obj.node_id, 1)
 
diff --git a/docs/sphinx/dbusparser.py b/docs/sphinx/dbusparser.py
index 024553eae7b..294dc2f8c2a 100644
--- a/docs/sphinx/dbusparser.py
+++ b/docs/sphinx/dbusparser.py
@@ -78,7 +78,7 @@ def __init__(self, name, signature, access):
         elif self.access == "write":
             self.writable = True
         else:
-            raise ValueError('Invalid access type "{}"'.format(self.access))
+            raise ValueError(f'Invalid access type "{self.access}"')
         self.doc_string = ""
         self.since = ""
         self.deprecated = False
@@ -277,7 +277,7 @@ def handle_start_element(self, name, attrs):
                 elif direction == "out":
                     self._cur_object.out_args.append(arg)
                 else:
-                    raise ValueError('Invalid direction "{}"'.format(direction))
+                    raise ValueError(f'Invalid direction "{direction}"')
                 self._cur_object = arg
             elif name == DBusXMLParser.STATE_ANNOTATION:
                 self.state = DBusXMLParser.STATE_ANNOTATION
diff --git a/docs/sphinx/depfile.py b/docs/sphinx/depfile.py
index d3c774d28b1..ab3c40f1049 100644
--- a/docs/sphinx/depfile.py
+++ b/docs/sphinx/depfile.py
@@ -1,4 +1,3 @@
-# coding=utf-8
 #
 # QEMU depfile generation extension
 #
@@ -11,17 +10,19 @@
    an external build system"""
 
 import os
-import sphinx
-import sys
 from pathlib import Path
+import sys
+
+import sphinx
+
 
 __version__ = '1.0'
 
 def get_infiles(env):
     for x in env.found_docs:
         yield str(env.doc2path(x))
-        yield from ((os.path.join(env.srcdir, dep)
-                    for dep in env.dependencies[x]))
+        yield from (os.path.join(env.srcdir, dep)
+                    for dep in env.dependencies[x])
     for mod in sys.modules.values():
         if hasattr(mod, '__file__'):
             if mod.__file__:
diff --git a/docs/sphinx/fakedbusdoc.py b/docs/sphinx/fakedbusdoc.py
index 2d2e6ef6403..dc2bb8c43bb 100644
--- a/docs/sphinx/fakedbusdoc.py
+++ b/docs/sphinx/fakedbusdoc.py
@@ -7,9 +7,10 @@
 # Author: Marc-André Lureau <marcandre.lureau@redhat.com>
 """dbus-doc is a Sphinx extension that provides documentation from D-Bus XML."""
 
+from typing import Any
+
 from docutils.parsers.rst import Directive
 from sphinx.application import Sphinx
-from typing import Any, Dict
 
 
 class FakeDBusDocDirective(Directive):
@@ -20,7 +21,7 @@ def run(self):
         return []
 
 
-def setup(app: Sphinx) -> Dict[str, Any]:
+def setup(app: Sphinx) -> dict[str, Any]:
     """Register a fake dbus-doc directive with Sphinx"""
     app.add_directive("dbus-doc", FakeDBusDocDirective)
 
diff --git a/docs/sphinx/hxtool.py b/docs/sphinx/hxtool.py
index a84723be19e..00f697ac984 100644
--- a/docs/sphinx/hxtool.py
+++ b/docs/sphinx/hxtool.py
@@ -1,4 +1,3 @@
-# coding=utf-8
 #
 # QEMU hxtool .hx file parsing extension
 #
@@ -16,17 +15,17 @@
 # Each hxtool-doc:: directive takes one argument which is the
 # path of the .hx file to process, relative to the source tree.
 
+from enum import Enum
 import os
 import re
-from enum import Enum
 
 from docutils import nodes
+from docutils.parsers.rst import Directive, directives
 from docutils.statemachine import ViewList
-from docutils.parsers.rst import directives, Directive
+import sphinx
 from sphinx.errors import ExtensionError
 from sphinx.util.docutils import switch_source_input
 from sphinx.util.nodes import nested_parse_with_titles
-import sphinx
 
 
 __version__ = '1.0'
diff --git a/docs/sphinx/kerneldoc.py b/docs/sphinx/kerneldoc.py
index 3aa972f2e89..23278b6b464 100644
--- a/docs/sphinx/kerneldoc.py
+++ b/docs/sphinx/kerneldoc.py
@@ -1,4 +1,3 @@
-# coding=utf-8
 #
 # Copyright © 2016 Intel Corporation
 #
@@ -28,16 +27,15 @@
 #
 
 import codecs
+import glob
 import os
+import re
 import subprocess
 import sys
-import re
-import glob
 
 from docutils import nodes, statemachine
+from docutils.parsers.rst import Directive, directives
 from docutils.statemachine import ViewList
-from docutils.parsers.rst import directives, Directive
-
 import sphinx
 from sphinx.util import logging
 from sphinx.util.docutils import switch_source_input
diff --git a/docs/sphinx/qapi_domain.py b/docs/sphinx/qapi_domain.py
index ebc46a72c61..cb6104922b5 100644
--- a/docs/sphinx/qapi_domain.py
+++ b/docs/sphinx/qapi_domain.py
@@ -9,14 +9,7 @@
 
 import re
 import types
-from typing import (
-    TYPE_CHECKING,
-    List,
-    NamedTuple,
-    Tuple,
-    Type,
-    cast,
-)
+from typing import TYPE_CHECKING, NamedTuple, cast
 
 from docutils import nodes
 from docutils.parsers.rst import directives
@@ -46,14 +39,8 @@
 
 
 if TYPE_CHECKING:
-    from typing import (
-        AbstractSet,
-        Any,
-        Dict,
-        Iterable,
-        Optional,
-        Union,
-    )
+    from collections.abc import Iterable
+    from typing import AbstractSet, Any
 
     from docutils.nodes import Element, Node
     from sphinx.addnodes import desc_signature, pending_xref
@@ -68,7 +55,7 @@
 
 def _unpack_field(
     field: nodes.Node,
-) -> Tuple[nodes.field_name, nodes.field_body]:
+) -> tuple[nodes.field_name, nodes.field_body]:
     """
     docutils helper: unpack a field node in a type-safe manner.
     """
@@ -140,11 +127,11 @@ def result_nodes(
         env: BuildEnvironment,
         node: Element,
         is_ref: bool,
-    ) -> Tuple[List[nodes.Node], List[nodes.system_message]]:
+    ) -> tuple[list[nodes.Node], list[nodes.system_message]]:
 
         # node here is the pending_xref node (or whatever nodeclass was
         # configured at XRefRole class instantiation time).
-        results: List[nodes.Node] = [node]
+        results: list[nodes.Node] = [node]
 
         if node.get("qapi:array"):
             results.insert(0, nodes.literal("[", "["))
@@ -178,13 +165,13 @@ def handle_signature(self, sig: str, signode: desc_signature) -> Signature:
         # subclasses will handle this.
         return sig
 
-    def get_index_text(self, name: Signature) -> Tuple[str, str]:
+    def get_index_text(self, name: Signature) -> tuple[str, str]:
         """Return the text for the index entry of the object."""
 
         # NB: this is used for the global index, not the QAPI index.
         return ("single", f"{name} (QMP {self.objtype})")
 
-    def _get_context(self) -> Tuple[str, str]:
+    def _get_context(self) -> tuple[str, str]:
         namespace = self.options.get(
             "namespace", self.env.ref_context.get("qapi:namespace", "")
         )
@@ -240,7 +227,7 @@ def add_target_and_index(
                 )
 
     @staticmethod
-    def split_fqn(name: str) -> Tuple[str, str, str]:
+    def split_fqn(name: str) -> tuple[str, str, str]:
         if ":" in name:
             ns, name = name.split(":")
         else:
@@ -255,7 +242,7 @@ def split_fqn(name: str) -> Tuple[str, str, str]:
 
     def _object_hierarchy_parts(
         self, sig_node: desc_signature
-    ) -> Tuple[str, ...]:
+    ) -> tuple[str, ...]:
         if "fullname" not in sig_node:
             return ()
         return self.split_fqn(sig_node["fullname"])
@@ -264,7 +251,7 @@ def _toc_entry_name(self, sig_node: desc_signature) -> str:
         # This controls the name in the TOC and on the sidebar.
 
         # This is the return type of _object_hierarchy_parts().
-        toc_parts = cast(Tuple[str, ...], sig_node.get("_toc_parts", ()))
+        toc_parts = cast(tuple[str, ...], sig_node.get("_toc_parts", ()))
         if not toc_parts:
             return ""
 
@@ -323,7 +310,7 @@ class QAPIObject(QAPIDescription):
         ),
     ]
 
-    def get_signature_prefix(self) -> List[nodes.Node]:
+    def get_signature_prefix(self) -> list[nodes.Node]:
         """Return a prefix to put before the object name in the signature."""
         assert self.objtype
         return [
@@ -331,9 +318,9 @@ def get_signature_prefix(self) -> List[nodes.Node]:
             SpaceNode(" "),
         ]
 
-    def get_signature_suffix(self) -> List[nodes.Node]:
+    def get_signature_suffix(self) -> list[nodes.Node]:
         """Return a suffix to put after the object name in the signature."""
-        ret: List[nodes.Node] = []
+        ret: list[nodes.Node] = []
 
         if "since" in self.options:
             ret += [
@@ -383,7 +370,7 @@ def _add_infopips(self, contentnode: addnodes.desc_content) -> None:
         infopips.attributes["classes"].append("qapi-infopips")
 
         def _add_pip(
-            source: str, content: Union[str, List[nodes.Node]], classname: str
+            source: str, content: str | list[nodes.Node], classname: str
         ) -> None:
             node = nodes.container(source)
             if isinstance(content, str):
@@ -626,7 +613,7 @@ class QAPIModule(QAPIDescription):
           Lorem ipsum, dolor sit amet ...
     """
 
-    def run(self) -> List[Node]:
+    def run(self) -> list[Node]:
         modname = self.arguments[0].strip()
         self.env.ref_context["qapi:module"] = modname
         ret = super().run()
@@ -641,11 +628,11 @@ def run(self) -> List[Node]:
         ret.extend(desc_node.children[1].children)
 
         # Re-home node_ids so anchor refs still work:
-        node_ids: List[str]
+        node_ids: list[str]
         if node_ids := [
             node_id
             for el in desc_node.children[0].traverse(nodes.Element)
-            for node_id in cast(List[str], el.get("ids", ()))
+            for node_id in cast(list[str], el.get("ids", ()))
         ]:
             target_node = nodes.target(ids=node_ids)
             ret.insert(1, target_node)
@@ -657,7 +644,7 @@ class QAPINamespace(SphinxDirective):
     has_content = False
     required_arguments = 1
 
-    def run(self) -> List[Node]:
+    def run(self) -> list[Node]:
         namespace = self.arguments[0].strip()
         self.env.ref_context["qapi:namespace"] = namespace
 
@@ -678,10 +665,10 @@ class QAPIIndex(Index):
 
     def generate(
         self,
-        docnames: Optional[Iterable[str]] = None,
-    ) -> Tuple[List[Tuple[str, List[IndexEntry]]], bool]:
+        docnames: Iterable[str] | None = None,
+    ) -> tuple[list[tuple[str, list[IndexEntry]]], bool]:
         assert isinstance(self.domain, QAPIDomain)
-        content: Dict[str, List[IndexEntry]] = {}
+        content: dict[str, list[IndexEntry]] = {}
         collapse = False
 
         for objname, obj in self.domain.objects.items():
@@ -733,7 +720,7 @@ class QAPIDomain(Domain):
     # e.g., the :qapi:type: cross-reference role can refer to enum,
     # struct, union, or alternate objects; but :qapi:obj: can refer to
     # anything. Each object also gets its own targeted cross-reference role.
-    object_types: Dict[str, ObjType] = {
+    object_types: dict[str, ObjType] = {
         "module": ObjType(_("module"), "mod", "any"),
         "command": ObjType(_("command"), "cmd", "any"),
         "event": ObjType(_("event"), "event", "any"),
@@ -771,7 +758,7 @@ class QAPIDomain(Domain):
 
     # Moved into the data property at runtime;
     # this is the internal index of reference-able objects.
-    initial_data: Dict[str, Dict[str, Tuple[Any]]] = {
+    initial_data: dict[str, dict[str, tuple[Any]]] = {
         "objects": {},  # fullname -> ObjectEntry
     }
 
@@ -781,14 +768,14 @@ class QAPIDomain(Domain):
     ]
 
     @property
-    def objects(self) -> Dict[str, ObjectEntry]:
+    def objects(self) -> dict[str, ObjectEntry]:
         ret = self.data.setdefault("objects", {})
         return ret  # type: ignore[no-any-return]
 
     def setup(self) -> None:
         namespaces = set(self.env.app.config.qapi_namespaces)
         for namespace in namespaces:
-            new_index: Type[QAPIIndex] = types.new_class(
+            new_index: type[QAPIIndex] = types.new_class(
                 f"{namespace}Index", bases=(QAPIIndex,)
             )
             new_index.name = f"{namespace.lower()}-index"
@@ -838,7 +825,7 @@ def clear_doc(self, docname: str) -> None:
                 del self.objects[fullname]
 
     def merge_domaindata(
-        self, docnames: AbstractSet[str], otherdata: Dict[str, Any]
+        self, docnames: AbstractSet[str], otherdata: dict[str, Any]
     ) -> None:
         for fullname, obj in otherdata["objects"].items():
             if obj.docname in docnames:
@@ -852,8 +839,8 @@ def merge_domaindata(
                 self.objects[fullname] = obj
 
     def find_obj(
-        self, namespace: str, modname: str, name: str, typ: Optional[str]
-    ) -> List[Tuple[str, ObjectEntry]]:
+        self, namespace: str, modname: str, name: str, typ: str | None
+    ) -> list[tuple[str, ObjectEntry]]:
         """
         Find a QAPI object for "name", maybe using contextual information.
 
@@ -890,7 +877,7 @@ def find_obj(
 
         if typ is None:
             # :any: lookup, search everything:
-            objtypes: List[str] = list(self.object_types)
+            objtypes: list[str] = list(self.object_types)
         else:
             # type is specified and will be a role (e.g. obj, mod, cmd)
             # convert this to eligible object types (e.g. command, module)
@@ -901,7 +888,7 @@ def find_obj(
         # search!
         # ##
 
-        def _search(needle: str) -> List[str]:
+        def _search(needle: str) -> list[str]:
             if (
                 needle
                 and needle in self.objects
@@ -1015,8 +1002,8 @@ def resolve_any_xref(
         target: str,
         node: pending_xref,
         contnode: Element,
-    ) -> List[Tuple[str, nodes.reference]]:
-        results: List[Tuple[str, nodes.reference]] = []
+    ) -> list[tuple[str, nodes.reference]]:
+        results: list[tuple[str, nodes.reference]] = []
         matches = self.find_obj(
             node.get("qapi:namespace"), node.get("qapi:module"), target, None
         )
@@ -1031,7 +1018,7 @@ def resolve_any_xref(
         return results
 
 
-def setup(app: Sphinx) -> Dict[str, Any]:
+def setup(app: Sphinx) -> dict[str, Any]:
     app.setup_extension("sphinx.directives")
     app.add_config_value(
         "qapi_allowed_fields",
diff --git a/docs/sphinx/qapidoc.py b/docs/sphinx/qapidoc.py
index 8011ac9efaf..5ca859b19a7 100644
--- a/docs/sphinx/qapidoc.py
+++ b/docs/sphinx/qapidoc.py
@@ -1,4 +1,3 @@
-# coding=utf-8
 #
 # QEMU qapidoc QAPI file parsing extension
 #
@@ -68,14 +67,8 @@
 
 
 if TYPE_CHECKING:
-    from typing import (
-        Any,
-        Generator,
-        List,
-        Optional,
-        Sequence,
-        Union,
-    )
+    from collections.abc import Generator, Sequence
+    from typing import Any
 
     from sphinx.application import Sphinx
     from sphinx.util.typing import ExtensionMetadata
@@ -98,7 +91,7 @@ class Transmogrifier:
     }
 
     def __init__(self) -> None:
-        self._curr_ent: Optional[QAPISchemaDefinition] = None
+        self._curr_ent: QAPISchemaDefinition | None = None
         self._result = StringList()
         self.indent = 0
 
@@ -132,7 +125,7 @@ def add_line_raw(self, line: str, source: str, *lineno: int) -> None:
         """Append one line of generated reST to the output."""
 
         # NB: Sphinx uses zero-indexed lines; subtract one.
-        lineno = tuple((n - 1 for n in lineno))
+        lineno = tuple(n - 1 for n in lineno)
 
         if line.strip():
             # not a blank line
@@ -176,7 +169,7 @@ def add_field(
         name: str,
         body: str,
         info: QAPISourceInfo,
-        typ: Optional[str] = None,
+        typ: str | None = None,
     ) -> None:
         if typ:
             text = f":{kind} {typ} {name}: {body}"
@@ -185,8 +178,8 @@ def add_field(
         self.add_lines(text, info)
 
     def format_type(
-        self, ent: Union[QAPISchemaDefinition | QAPISchemaMember]
-    ) -> Optional[str]:
+        self, ent: QAPISchemaDefinition | QAPISchemaMember
+    ) -> str | None:
         if isinstance(ent, (QAPISchemaEnumMember, QAPISchemaFeature)):
             return None
 
@@ -306,7 +299,7 @@ def _insert_member_pointer(self, ent: QAPISchemaDefinition) -> None:
 
         def _get_target(
             ent: QAPISchemaDefinition,
-        ) -> Optional[QAPISchemaDefinition]:
+        ) -> QAPISchemaDefinition | None:
             if isinstance(ent, (QAPISchemaCommand, QAPISchemaEvent)):
                 return ent.arg_type
             if isinstance(ent, QAPISchemaObjectType):
@@ -674,7 +667,7 @@ def _highlightlang(self) -> addnodes.highlightlang:
         )
         return node
 
-    def admonition_wrap(self, *content: nodes.Node) -> List[nodes.Node]:
+    def admonition_wrap(self, *content: nodes.Node) -> list[nodes.Node]:
         title = "Example:"
         if "title" in self.options:
             title = f"{title} {self.options['title']}"
@@ -687,7 +680,7 @@ def admonition_wrap(self, *content: nodes.Node) -> List[nodes.Node]:
         )
         return [admon]
 
-    def run_annotated(self) -> List[nodes.Node]:
+    def run_annotated(self) -> list[nodes.Node]:
         lang_node = self._highlightlang()
 
         content_node: nodes.Element = nodes.section()
@@ -708,7 +701,7 @@ def run_annotated(self) -> List[nodes.Node]:
 
         return content_node.children
 
-    def run(self) -> List[nodes.Node]:
+    def run(self) -> list[nodes.Node]:
         annotated = "annotated" in self.options
 
         if annotated:
diff --git a/docs/sphinx/qapidoc_legacy.py b/docs/sphinx/qapidoc_legacy.py
index 13520f4c26b..071fb55f94f 100644
--- a/docs/sphinx/qapidoc_legacy.py
+++ b/docs/sphinx/qapidoc_legacy.py
@@ -1,4 +1,3 @@
-# coding=utf-8
 # type: ignore
 #
 # QEMU qapidoc QAPI file parsing extension
diff --git a/docs/sphinx/qmp_lexer.py b/docs/sphinx/qmp_lexer.py
index 7b3b808d124..77653a900cd 100644
--- a/docs/sphinx/qmp_lexer.py
+++ b/docs/sphinx/qmp_lexer.py
@@ -10,11 +10,12 @@
 # See the COPYING file in the top-level directory.
 """qmp_lexer is a Sphinx extension that provides a QMP lexer for code blocks."""
 
-from pygments.lexer import RegexLexer, DelegatingLexer
-from pygments.lexers.data import JsonLexer
 from pygments import token
+from pygments.lexer import DelegatingLexer, RegexLexer
+from pygments.lexers.data import JsonLexer
 from sphinx import errors
 
+
 class QMPExampleMarkersLexer(RegexLexer):
     """
     QMPExampleMarkersLexer lexes QMP example annotations.
@@ -31,7 +32,7 @@ class QMPExampleMarkersLexer(RegexLexer):
 class QMPExampleLexer(DelegatingLexer):
     """QMPExampleLexer lexes annotated QMP examples."""
     def __init__(self, **options):
-        super(QMPExampleLexer, self).__init__(JsonLexer, QMPExampleMarkersLexer,
+        super().__init__(JsonLexer, QMPExampleMarkersLexer,
                                               token.Error, **options)
 
 def setup(sphinx):
diff --git a/.gitlab-ci.d/check-dco.py b/.gitlab-ci.d/check-dco.py
index 2fd56683dc6..5863396f589 100755
--- a/.gitlab-ci.d/check-dco.py
+++ b/.gitlab-ci.d/check-dco.py
@@ -8,8 +8,9 @@
 
 import os
 import os.path
-import sys
 import subprocess
+import sys
+
 
 namespace = "qemu-project"
 if len(sys.argv) >= 2:
@@ -25,7 +26,7 @@
 
 ancestor = subprocess.check_output(["git", "merge-base",
                                     "check-dco/master", "HEAD"],
-                                   universal_newlines=True)
+                                   text=True)
 
 ancestor = ancestor.strip()
 
@@ -38,7 +39,7 @@
 
 log = subprocess.check_output(["git", "log", "--format=%H %s",
                                ancestor + "..."],
-                              universal_newlines=True)
+                              text=True)
 
 if log == "":
     commits = []
@@ -48,7 +49,7 @@
 for sha, subject in commits:
 
     msg = subprocess.check_output(["git", "show", "-s", sha],
-                                  universal_newlines=True)
+                                  text=True)
     lines = msg.strip().split("\n")
 
     print("🔍 %s %s" % (sha, subject))
diff --git a/.gitlab-ci.d/check-patch.py b/.gitlab-ci.d/check-patch.py
index be13e6f77d7..49151c465f4 100755
--- a/.gitlab-ci.d/check-patch.py
+++ b/.gitlab-ci.d/check-patch.py
@@ -8,8 +8,9 @@
 
 import os
 import os.path
-import sys
 import subprocess
+import sys
+
 
 namespace = "qemu-project"
 if len(sys.argv) >= 2:
@@ -28,13 +29,13 @@
 
 ancestor = subprocess.check_output(["git", "merge-base",
                                     "check-patch/master", "HEAD"],
-                                   universal_newlines=True)
+                                   text=True)
 
 ancestor = ancestor.strip()
 
 log = subprocess.check_output(["git", "log", "--format=%H %s",
                                ancestor + "..."],
-                              universal_newlines=True)
+                              text=True)
 
 subprocess.check_call(["git", "remote", "rm", "check-patch"])
 
diff --git a/.gitlab-ci.d/check-units.py b/.gitlab-ci.d/check-units.py
index 268a4118d59..1640ea6f21a 100755
--- a/.gitlab-ci.d/check-units.py
+++ b/.gitlab-ci.d/check-units.py
@@ -7,10 +7,10 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from os import access, R_OK, path
-from sys import argv, exit
-import json
 from collections import Counter
+import json
+from os import R_OK, access, path
+from sys import argv, exit
 
 
 def extract_build_units(cc_path):
@@ -21,7 +21,7 @@ def extract_build_units(cc_path):
         Hash table of ["unit"] = count
     """
 
-    j = json.load(open(cc_path, 'r'))
+    j = json.load(open(cc_path))
     files = [f['file'] for f in j]
     build_units = Counter(files)
 
diff --git a/python/qemu/machine/console_socket.py b/python/qemu/machine/console_socket.py
index 0a4e09ffc73..0754f340310 100644
--- a/python/qemu/machine/console_socket.py
+++ b/python/qemu/machine/console_socket.py
@@ -123,7 +123,7 @@ def recv(self, bufsize: int = 1, flags: int = 0) -> bytes:
             elapsed_sec = time.time() - start_time
             if elapsed_sec > self._recv_timeout_sec:
                 raise socket.timeout
-        return bytes((self._buffer.popleft() for i in range(bufsize)))
+        return bytes(self._buffer.popleft() for i in range(bufsize))
 
     def setblocking(self, value: bool) -> None:
         """When not draining we pass thru to the socket,
diff --git a/python/qemu/machine/machine.py b/python/qemu/machine/machine.py
index ebb58d5b68c..5dfba3b6ea5 100644
--- a/python/qemu/machine/machine.py
+++ b/python/qemu/machine/machine.py
@@ -17,6 +17,7 @@
 # Based on qmp.py.
 #
 
+from collections.abc import Sequence
 import errno
 from itertools import chain
 import locale
@@ -31,12 +32,7 @@
 from typing import (
     Any,
     BinaryIO,
-    Dict,
-    List,
     Optional,
-    Sequence,
-    Tuple,
-    Type,
     TypeVar,
 )
 
@@ -156,9 +152,9 @@ def __init__(self,
         self._qmp_timer = qmp_timer
 
         self._name = name or f"{id(self):x}"
-        self._sock_pair: Optional[Tuple[socket.socket, socket.socket]] = None
+        self._sock_pair: Optional[tuple[socket.socket, socket.socket]] = None
         self._cons_sock_pair: Optional[
-            Tuple[socket.socket, socket.socket]] = None
+            tuple[socket.socket, socket.socket]] = None
         self._temp_dir: Optional[str] = None
         self._base_temp_dir = base_temp_dir
         self._log_dir = log_dir
@@ -176,11 +172,11 @@ def __init__(self,
         self._qemu_log_path: Optional[str] = None
         self._qemu_log_file: Optional[BinaryIO] = None
         self._popen: Optional['subprocess.Popen[bytes]'] = None
-        self._events: List[QMPMessage] = []
+        self._events: list[QMPMessage] = []
         self._iolog: Optional[str] = None
         self._qmp_set = True   # Enable QMP monitor by default.
         self._qmp_connection: Optional[QEMUMonitorProtocol] = None
-        self._qemu_full_args: Tuple[str, ...] = ()
+        self._qemu_full_args: tuple[str, ...] = ()
         self._launched = False
         self._machine: Optional[str] = None
         self._console_index = 0
@@ -188,7 +184,7 @@ def __init__(self,
         self._console_device_type: Optional[str] = None
         self._console_socket: Optional[socket.socket] = None
         self._console_file: Optional[socket.SocketIO] = None
-        self._remove_files: List[str] = []
+        self._remove_files: list[str] = []
         self._user_killed = False
         self._quit_issued = False
 
@@ -196,7 +192,7 @@ def __enter__(self: _T) -> _T:
         return self
 
     def __exit__(self,
-                 exc_type: Optional[Type[BaseException]],
+                 exc_type: Optional[type[BaseException]],
                  exc_val: Optional[BaseException],
                  exc_tb: Optional[TracebackType]) -> None:
         self.shutdown()
@@ -288,11 +284,11 @@ def _load_io_log(self) -> None:
         # back to the platform default.
         _, encoding = locale.getlocale()
         if self._qemu_log_path is not None:
-            with open(self._qemu_log_path, "r", encoding=encoding) as iolog:
+            with open(self._qemu_log_path, encoding=encoding) as iolog:
                 self._iolog = iolog.read()
 
     @property
-    def _base_args(self) -> List[str]:
+    def _base_args(self) -> list[str]:
         args = ['-display', 'none', '-vga', 'none']
 
         if self._qmp_set:
@@ -324,7 +320,7 @@ def _base_args(self) -> List[str]:
         return args
 
     @property
-    def args(self) -> List[str]:
+    def args(self) -> list[str]:
         """Returns the list of arguments given to the QEMU binary."""
         return self._args
 
@@ -685,14 +681,14 @@ def _qmp(self) -> QEMUMonitorProtocol:
 
     @classmethod
     def _qmp_args(cls, conv_keys: bool,
-                  args: Dict[str, Any]) -> Dict[str, object]:
+                  args: dict[str, Any]) -> dict[str, object]:
         if conv_keys:
             return {k.replace('_', '-'): v for k, v in args.items()}
 
         return args
 
     def qmp(self, cmd: str,
-            args_dict: Optional[Dict[str, object]] = None,
+            args_dict: Optional[dict[str, object]] = None,
             conv_keys: Optional[bool] = None,
             **args: Any) -> QMPMessage:
         """
@@ -714,7 +710,7 @@ def qmp(self, cmd: str,
         return ret
 
     def cmd(self, cmd: str,
-            args_dict: Optional[Dict[str, object]] = None,
+            args_dict: Optional[dict[str, object]] = None,
             conv_keys: Optional[bool] = None,
             **args: Any) -> QMPReturnValue:
         """
@@ -745,7 +741,7 @@ def get_qmp_event(self, wait: bool = False) -> Optional[QMPMessage]:
             return self._events.pop(0)
         return self._qmp.pull_event(wait=wait)
 
-    def get_qmp_events(self, wait: bool = False) -> List[QMPMessage]:
+    def get_qmp_events(self, wait: bool = False) -> list[QMPMessage]:
         """
         Poll for queued QMP events and return a list of dicts
         """
@@ -800,7 +796,7 @@ def event_wait(self, name: str,
         return self.events_wait([(name, match)], timeout)
 
     def events_wait(self,
-                    events: Sequence[Tuple[str, Any]],
+                    events: Sequence[tuple[str, Any]],
                     timeout: float = 60.0) -> Optional[QMPMessage]:
         """
         events_wait waits for and returns a single named event from QMP.
diff --git a/python/qemu/machine/qtest.py b/python/qemu/machine/qtest.py
index 4f5ede85b23..bc6364f02f0 100644
--- a/python/qemu/machine/qtest.py
+++ b/python/qemu/machine/qtest.py
@@ -17,15 +17,10 @@
 # Based on qmp.py.
 #
 
+from collections.abc import Sequence
 import os
 import socket
-from typing import (
-    List,
-    Optional,
-    Sequence,
-    TextIO,
-    Tuple,
-)
+from typing import Optional, TextIO
 
 from qemu.qmp import SocketAddrT
 
@@ -145,10 +140,10 @@ def __init__(self,
                          qmp_timer=qmp_timer)
         self._qtest: Optional[QEMUQtestProtocol] = None
         self._qtest_sock_pair: Optional[
-            Tuple[socket.socket, socket.socket]] = None
+            tuple[socket.socket, socket.socket]] = None
 
     @property
-    def _base_args(self) -> List[str]:
+    def _base_args(self) -> list[str]:
         args = super()._base_args
         assert self._qtest_sock_pair is not None
         fd = self._qtest_sock_pair[0].fileno()
diff --git a/python/qemu/qmp/events.py b/python/qemu/qmp/events.py
index cfb5f0ac621..e444d9334ec 100644
--- a/python/qemu/qmp/events.py
+++ b/python/qemu/qmp/events.py
@@ -448,19 +448,10 @@ def accept(self, event) -> bool:
 """
 
 import asyncio
+from collections.abc import AsyncIterator, Iterable, Iterator
 from contextlib import contextmanager
 import logging
-from typing import (
-    AsyncIterator,
-    Callable,
-    Iterable,
-    Iterator,
-    List,
-    Optional,
-    Set,
-    Tuple,
-    Union,
-)
+from typing import Callable, Optional, Union
 
 from .error import QMPError
 from .message import Message
@@ -504,10 +495,10 @@ def __init__(
         self._queue: 'asyncio.Queue[Message]' = asyncio.Queue()
 
         # Intended as a historical record, NOT a processing queue or backlog.
-        self._history: List[Message] = []
+        self._history: list[Message] = []
 
         #: Primary event filter, based on one or more event names.
-        self.names: Set[str] = set()
+        self.names: set[str] = set()
         if isinstance(names, str):
             self.names.add(names)
         elif names is not None:
@@ -517,7 +508,7 @@ def __init__(
         self.event_filter: Optional[EventFilter] = event_filter
 
     def __repr__(self) -> str:
-        args: List[str] = []
+        args: list[str] = []
         if self.names:
             args.append(f"names={self.names!r}")
         if self.event_filter:
@@ -532,7 +523,7 @@ def __repr__(self) -> str:
         return f"{type(self).__name__}{state}({argstr})"
 
     @property
-    def history(self) -> Tuple[Message, ...]:
+    def history(self) -> tuple[Message, ...]:
         """
         A read-only history of all events seen so far.
 
@@ -596,7 +587,7 @@ def empty(self) -> bool:
         """
         return self._queue.empty()
 
-    def clear(self) -> List[Message]:
+    def clear(self) -> list[Message]:
         """
         Clear this listener of all pending events.
 
@@ -650,7 +641,7 @@ class Events:
     property.
     """
     def __init__(self) -> None:
-        self._listeners: List[EventListener] = []
+        self._listeners: list[EventListener] = []
 
         #: Default, all-events `EventListener`. See `qmp.events` for more info.
         self.events: EventListener = EventListener()
diff --git a/python/qemu/qmp/legacy.py b/python/qemu/qmp/legacy.py
index 9606e731864..584c4de0433 100644
--- a/python/qemu/qmp/legacy.py
+++ b/python/qemu/qmp/legacy.py
@@ -22,15 +22,12 @@
 #
 
 import asyncio
+from collections.abc import Awaitable
 import socket
 from types import TracebackType
 from typing import (
     Any,
-    Awaitable,
-    Dict,
-    List,
     Optional,
-    Type,
     TypeVar,
     Union,
 )
@@ -41,13 +38,13 @@
 
 
 #: QMPMessage is an entire QMP message of any kind.
-QMPMessage = Dict[str, Any]
+QMPMessage = dict[str, Any]
 
 #: QMPReturnValue is the 'return' value of a command.
 QMPReturnValue = object
 
 #: QMPObject is any object in a QMP message.
-QMPObject = Dict[str, object]
+QMPObject = dict[str, object]
 
 # QMPMessage can be outgoing commands or incoming events/returns.
 # QMPReturnValue is usually a dict/json object, but due to QAPI's
@@ -121,7 +118,7 @@ def __enter__(self: _T) -> _T:
         return self
 
     def __exit__(self,
-                 exc_type: Optional[Type[BaseException]],
+                 exc_type: Optional[type[BaseException]],
                  exc_val: Optional[BaseException],
                  exc_tb: Optional[TracebackType]) -> None:
         # Implement context manager exit function.
@@ -202,7 +199,7 @@ def cmd_obj(self, qmp_cmd: QMPMessage) -> QMPMessage:
         )
 
     def cmd_raw(self, name: str,
-                args: Optional[Dict[str, object]] = None) -> QMPMessage:
+                args: Optional[dict[str, object]] = None) -> QMPMessage:
         """
         Build a QMP command and send it to the QMP Monitor.
 
@@ -260,7 +257,7 @@ def pull_event(self,
             )
         )
 
-    def get_events(self, wait: Union[bool, float] = False) -> List[QMPMessage]:
+    def get_events(self, wait: Union[bool, float] = False) -> list[QMPMessage]:
         """
         Get a list of QMP events and clear all pending events.
 
diff --git a/python/qemu/qmp/message.py b/python/qemu/qmp/message.py
index dabb8ec360e..0a4371307df 100644
--- a/python/qemu/qmp/message.py
+++ b/python/qemu/qmp/message.py
@@ -5,16 +5,10 @@
 message sent to or from the server.
 """
 
+from collections.abc import Iterator, Mapping, MutableMapping
 import json
 from json import JSONDecodeError
-from typing import (
-    Dict,
-    Iterator,
-    Mapping,
-    MutableMapping,
-    Optional,
-    Union,
-)
+from typing import Optional, Union
 
 from .error import ProtocolError
 
@@ -71,7 +65,7 @@ def __init__(self,
                  value: Union[bytes, Mapping[str, object]] = b'{}', *,
                  eager: bool = True):
         self._data: Optional[bytes] = None
-        self._obj: Optional[Dict[str, object]] = None
+        self._obj: Optional[dict[str, object]] = None
 
         if isinstance(value, bytes):
             self._data = value
@@ -125,7 +119,7 @@ def __bytes__(self) -> bytes:
     # Conversion Methods
 
     @property
-    def _object(self) -> Dict[str, object]:
+    def _object(self) -> dict[str, object]:
         """
         A `dict` representing this QMP message.
 
@@ -150,7 +144,7 @@ def _serialize(cls, value: object) -> bytes:
         return json.dumps(value, separators=(',', ':')).encode('utf-8')
 
     @classmethod
-    def _deserialize(cls, data: bytes) -> Dict[str, object]:
+    def _deserialize(cls, data: bytes) -> dict[str, object]:
         """
         Deserialize JSON `bytes` into a native Python `dict`.
 
diff --git a/python/qemu/qmp/models.py b/python/qemu/qmp/models.py
index 19dbe8781f4..3588e81be0f 100644
--- a/python/qemu/qmp/models.py
+++ b/python/qemu/qmp/models.py
@@ -8,14 +8,9 @@
 # pylint: disable=too-few-public-methods
 
 from collections import abc
+from collections.abc import Mapping, Sequence
 import copy
-from typing import (
-    Any,
-    Dict,
-    Mapping,
-    Optional,
-    Sequence,
-)
+from typing import Any, Optional
 
 
 class Model:
@@ -72,7 +67,7 @@ def __init__(self, raw: Mapping[str, Any]):
         self._check_member('QMP', abc.Mapping, "JSON object")
         self.QMP = QMPGreeting(self._raw['QMP'])
 
-    def _asdict(self) -> Dict[str, object]:
+    def _asdict(self) -> dict[str, object]:
         """
         For compatibility with the iotests sync QMP wrapper.
 
diff --git a/python/qemu/qmp/protocol.py b/python/qemu/qmp/protocol.py
index 26486889d02..4ec9564c4b3 100644
--- a/python/qemu/qmp/protocol.py
+++ b/python/qemu/qmp/protocol.py
@@ -15,6 +15,7 @@
 
 import asyncio
 from asyncio import StreamReader, StreamWriter
+from collections.abc import AsyncGenerator, Awaitable
 from contextlib import asynccontextmanager
 from enum import Enum
 from functools import wraps
@@ -24,13 +25,9 @@
 from ssl import SSLContext
 from typing import (
     Any,
-    AsyncGenerator,
-    Awaitable,
     Callable,
     Generic,
-    List,
     Optional,
-    Tuple,
     TypeVar,
     Union,
     cast,
@@ -50,7 +47,7 @@
 _U = TypeVar('_U')
 _TaskFN = Callable[[], Awaitable[None]]  # aka ``async def func() -> None``
 
-InternetAddrT = Tuple[str, int]
+InternetAddrT = tuple[str, int]
 UnixAddrT = str
 SocketAddrT = Union[UnixAddrT, InternetAddrT]
 
@@ -248,7 +245,7 @@ def __init__(self, name: Optional[str] = None) -> None:
         self._writer_task: Optional[asyncio.Future[None]] = None
 
         # Aggregate of the above two tasks, used for Exception management.
-        self._bh_tasks: Optional[asyncio.Future[Tuple[None, None]]] = None
+        self._bh_tasks: Optional[asyncio.Future[tuple[None, None]]] = None
 
         #: Disconnect task. The disconnect implementation runs in a task
         #: so that asynchronous disconnects (initiated by the
@@ -744,7 +741,7 @@ async def _wait_disconnect(self) -> None:
         assert self.runstate == Runstate.DISCONNECTING
         assert self._dc_task
 
-        aws: List[Awaitable[object]] = [self._dc_task]
+        aws: list[Awaitable[object]] = [self._dc_task]
         if self._bh_tasks:
             aws.insert(0, self._bh_tasks)
         all_defined_tasks = asyncio.gather(*aws)
diff --git a/python/qemu/qmp/qmp_client.py b/python/qemu/qmp/qmp_client.py
index 55508ff73f3..5b91314bdad 100644
--- a/python/qemu/qmp/qmp_client.py
+++ b/python/qemu/qmp/qmp_client.py
@@ -8,17 +8,11 @@
 """
 
 import asyncio
+from collections.abc import Mapping
 import logging
 import socket
 import struct
-from typing import (
-    Dict,
-    List,
-    Mapping,
-    Optional,
-    Union,
-    cast,
-)
+from typing import Optional, Union, cast
 
 from .error import ProtocolError, QMPError
 from .events import Events
@@ -262,7 +256,7 @@ def __init__(self, name: Optional[str] = None) -> None:
         self._execute_id = 0
 
         # Incoming RPC reply messages.
-        self._pending: Dict[
+        self._pending: dict[
             Union[str, None],
             'asyncio.Queue[QMPClient._PendingT]'
         ] = {}
@@ -339,7 +333,7 @@ async def _negotiate(self) -> None:
         """
         self.logger.debug("Negotiating capabilities ...")
 
-        arguments: Dict[str, List[str]] = {}
+        arguments: dict[str, list[str]] = {}
         if self._greeting and 'oob' in self._greeting.QMP.capabilities:
             arguments.setdefault('enable', []).append('oob')
         msg = self.make_execute_msg('qmp_capabilities', arguments=arguments)
diff --git a/python/qemu/qmp/qmp_shell.py b/python/qemu/qmp/qmp_shell.py
index c39ba4be165..33c985d9dba 100644
--- a/python/qemu/qmp/qmp_shell.py
+++ b/python/qemu/qmp/qmp_shell.py
@@ -125,6 +125,7 @@
 
 import argparse
 import ast
+from collections.abc import Iterator, Sequence
 import json
 import logging
 import os
@@ -134,12 +135,8 @@
 import sys
 from typing import (
     IO,
-    Dict,
-    Iterator,
-    List,
     NoReturn,
     Optional,
-    Sequence,
     cast,
 )
 
@@ -167,7 +164,7 @@ class QMPCompleter:
     # NB: Python 3.9+ will probably allow us to subclass list[str] directly,
     # but pylint as of today does not know that List[str] is simply 'list'.
     def __init__(self) -> None:
-        self._matches: List[str] = []
+        self._matches: list[str] = []
 
     def append(self, value: str) -> None:
         """Append a new valid completion to the list of possibilities."""
@@ -229,7 +226,7 @@ def __init__(self, address: SocketAddrT,
         self._greeting: Optional[QMPMessage] = None
         self._completer = QMPCompleter()
         self._transmode = False
-        self._actions: List[QMPMessage] = []
+        self._actions: list[QMPMessage] = []
         self._histfile = os.path.join(os.path.expanduser('~'),
                                       '.qmp-shell_history')
         self.pretty = pretty
@@ -246,7 +243,7 @@ def close(self) -> None:
 
     def _fill_completion(self) -> None:
         try:
-            cmds = cast(List[Dict[str, str]], self.cmd('query-commands'))
+            cmds = cast(list[dict[str, str]], self.cmd('query-commands'))
             for cmd in cmds:
                 self._completer.append(cmd['name'])
         except ExecuteError:
@@ -265,14 +262,14 @@ def _completer_setup(self) -> None:
             readline.read_history_file(self._histfile)
         except FileNotFoundError:
             pass
-        except IOError as err:
+        except OSError as err:
             msg = f"Failed to read history '{self._histfile}': {err!s}"
             LOG.warning(msg)
 
     def _save_history(self) -> None:
         try:
             readline.write_history_file(self._histfile)
-        except IOError as err:
+        except OSError as err:
             msg = f"Failed to save history file '{self._histfile}': {err!s}"
             LOG.warning(msg)
 
diff --git a/python/qemu/qmp/qmp_tui.py b/python/qemu/qmp/qmp_tui.py
index 12bdc17c99e..0cf91e83670 100644
--- a/python/qemu/qmp/qmp_tui.py
+++ b/python/qemu/qmp/qmp_tui.py
@@ -22,14 +22,7 @@
 from logging import Handler, LogRecord
 import signal
 import sys
-from typing import (
-    List,
-    Optional,
-    Tuple,
-    Type,
-    Union,
-    cast,
-)
+from typing import Optional, Union, cast
 
 
 try:
@@ -120,7 +113,7 @@ def format_json(msg: str) -> str:
 
 
 def has_handler_type(logger: logging.Logger,
-                     handler_type: Type[Handler]) -> bool:
+                     handler_type: type[Handler]) -> bool:
     """
     The Logger class has no interface to check if a certain type of handler is
     installed or not. So we provide an interface to do so.
@@ -151,7 +144,7 @@ class App(QMPClient):
     :param retry_delay:
         The delay(sec) before each retry
     """
-    def __init__(self, address: Union[str, Tuple[str, int]], num_retries: int,
+    def __init__(self, address: Union[str, tuple[str, int]], num_retries: int,
                  retry_delay: Optional[int]) -> None:
         urwid.register_signal(type(self), UPDATE_MSG)
         self.window = Window(self)
@@ -448,11 +441,11 @@ class Editor(urwid_readline.ReadlineEdit):
     def __init__(self, parent: App) -> None:
         super().__init__(caption='> ', multiline=True)
         self.parent = parent
-        self.history: List[str] = []
+        self.history: list[str] = []
         self.last_index: int = -1
         self.show_history: bool = False
 
-    def keypress(self, size: Tuple[int, int], key: str) -> Optional[str]:
+    def keypress(self, size: tuple[int, int], key: str) -> Optional[str]:
         """
         Handles the keypress on this widget.
 
@@ -530,7 +523,7 @@ def __init__(self, parent: App) -> None:
         super().__init__(self.history)
 
     def add_to_history(self,
-                       history: Union[str, List[Tuple[str, str]]]) -> None:
+                       history: Union[str, list[tuple[str, str]]]) -> None:
         """
         Appends a message to the list and set the focus to the last appended
         message.
@@ -541,7 +534,7 @@ def add_to_history(self,
         self.history.append(urwid.Text(history))
         self.history.set_focus(len(self.history) - 1)
 
-    def mouse_event(self, size: Tuple[int, int], _event: str, button: float,
+    def mouse_event(self, size: tuple[int, int], _event: str, button: float,
                     _x: int, _y: int, focus: bool) -> None:
         # Unfortunately there are no urwid constants that represent the mouse
         # events.
diff --git a/python/qemu/utils/accel.py b/python/qemu/utils/accel.py
index 386ff640ca8..0f8e45203d0 100644
--- a/python/qemu/utils/accel.py
+++ b/python/qemu/utils/accel.py
@@ -17,7 +17,7 @@
 import logging
 import os
 import subprocess
-from typing import List, Optional
+from typing import Optional
 
 
 LOG = logging.getLogger(__name__)
@@ -31,7 +31,7 @@
 }
 
 
-def list_accel(qemu_bin: str) -> List[str]:
+def list_accel(qemu_bin: str) -> list[str]:
     """
     List accelerators enabled in the QEMU binary.
 
@@ -43,7 +43,7 @@ def list_accel(qemu_bin: str) -> List[str]:
         return []
     try:
         out = subprocess.check_output([qemu_bin, '-accel', 'help'],
-                                      universal_newlines=True)
+                                      text=True)
     except:
         LOG.debug("Failed to get the list of accelerators in %s", qemu_bin)
         raise
diff --git a/python/qemu/utils/qemu_ga_client.py b/python/qemu/utils/qemu_ga_client.py
index cf0fcf9a8bb..a653c234c4b 100644
--- a/python/qemu/utils/qemu_ga_client.py
+++ b/python/qemu/utils/qemu_ga_client.py
@@ -39,16 +39,11 @@
 import argparse
 import asyncio
 import base64
+from collections.abc import Sequence
 import os
 import random
 import sys
-from typing import (
-    Any,
-    Callable,
-    Dict,
-    Optional,
-    Sequence,
-)
+from typing import Any, Callable, Optional
 
 from qemu.qmp import ConnectError, SocketAddrT
 from qemu.qmp.legacy import QEMUMonitorProtocol
@@ -76,7 +71,7 @@ def __init__(self, address: SocketAddrT):
     def sync(self, timeout: Optional[float] = 3) -> None:
         # Avoid being blocked forever
         if not self.ping(timeout):
-            raise EnvironmentError('Agent seems not alive')
+            raise OSError('Agent seems not alive')
         uid = random.randint(0, (1 << 32) - 1)
         while True:
             ret = self.qga.sync(id=uid)
@@ -159,7 +154,7 @@ def fsfreeze(self, cmd: str) -> object:
         # Can be int (freeze, thaw) or GuestFsfreezeStatus (status)
         return getattr(self.qga, 'fsfreeze' + '_' + cmd)()
 
-    def fstrim(self, minimum: int) -> Dict[str, object]:
+    def fstrim(self, minimum: int) -> dict[str, object]:
         # returns GuestFilesystemTrimResponse
         ret = getattr(self.qga, 'fstrim')(minimum=minimum)
         assert isinstance(ret, dict)
diff --git a/python/qemu/utils/qom_common.py b/python/qemu/utils/qom_common.py
index dd2c8b1908c..c4c81da8dca 100644
--- a/python/qemu/utils/qom_common.py
+++ b/python/qemu/utils/qom_common.py
@@ -18,14 +18,7 @@
 import argparse
 import os
 import sys
-from typing import (
-    Any,
-    Dict,
-    List,
-    Optional,
-    Type,
-    TypeVar,
-)
+from typing import Any, Optional, TypeVar
 
 from qemu.qmp import QMPError
 from qemu.qmp.legacy import QEMUMonitorProtocol
@@ -44,7 +37,7 @@ def __init__(self, name: str, type_: str,
         self.default_value = default_value
 
     @classmethod
-    def make(cls, value: Dict[str, Any]) -> 'ObjectPropertyInfo':
+    def make(cls, value: dict[str, Any]) -> 'ObjectPropertyInfo':
         """
         Build an ObjectPropertyInfo from a Dict with an unknown shape.
         """
@@ -136,7 +129,7 @@ def run(self) -> int:
         """
         raise NotImplementedError
 
-    def qom_list(self, path: str) -> List[ObjectPropertyInfo]:
+    def qom_list(self, path: str) -> list[ObjectPropertyInfo]:
         """
         :return: a strongly typed list from the 'qom-list' command.
         """
@@ -147,7 +140,7 @@ def qom_list(self, path: str) -> List[ObjectPropertyInfo]:
 
     @classmethod
     def command_runner(
-            cls: Type[CommandT],
+            cls: type[CommandT],
             args: argparse.Namespace
     ) -> int:
         """
diff --git a/python/qemu/utils/qom_fuse.py b/python/qemu/utils/qom_fuse.py
index cf7e344bd53..c1f596e3273 100644
--- a/python/qemu/utils/qom_fuse.py
+++ b/python/qemu/utils/qom_fuse.py
@@ -33,21 +33,14 @@
 ##
 
 import argparse
+from collections.abc import Iterator, Mapping
 from errno import ENOENT, EPERM
 import stat
 import sys
-from typing import (
-    IO,
-    Dict,
-    Iterator,
-    Mapping,
-    Optional,
-    Union,
-)
+from typing import IO, Optional, Union
 
 import fuse
 from fuse import FUSE, FuseOSError, Operations
-
 from qemu.qmp import ExecuteError
 
 from .qom_common import QOMCommand
@@ -79,7 +72,7 @@ def configure_parser(cls, parser: argparse.ArgumentParser) -> None:
     def __init__(self, args: argparse.Namespace):
         super().__init__(args)
         self.mount = args.mount
-        self.ino_map: Dict[str, int] = {}
+        self.ino_map: dict[str, int] = {}
         self.ino_count = 1
 
     def run(self) -> int:
diff --git a/python/scripts/mkvenv.py b/python/scripts/mkvenv.py
index 8ac5b0b2a05..8026ca24861 100644
--- a/python/scripts/mkvenv.py
+++ b/python/scripts/mkvenv.py
@@ -58,6 +58,7 @@
 # later. See the COPYING file in the top-level directory.
 
 import argparse
+from collections.abc import Iterator, Sequence
 from importlib.metadata import (
     Distribution,
     EntryPoint,
@@ -76,15 +77,7 @@
 import sys
 import sysconfig
 from types import SimpleNamespace
-from typing import (
-    Any,
-    Dict,
-    Iterator,
-    Optional,
-    Sequence,
-    Tuple,
-    Union,
-)
+from typing import Any, Optional, Union
 import venv
 
 
@@ -510,7 +503,7 @@ def diagnose(
     online: bool,
     wheels_dir: Optional[Union[str, Path]],
     prog: Optional[str],
-) -> Tuple[str, bool]:
+) -> tuple[str, bool]:
     """
     Offer a summary to the user as to why a package failed to be installed.
 
@@ -623,7 +616,7 @@ def pip_install(
     )
 
 
-def _make_version_constraint(info: Dict[str, str], install: bool) -> str:
+def _make_version_constraint(info: dict[str, str], install: bool) -> str:
     """
     Construct the version constraint part of a PEP 508 dependency
     specification (for example '>=0.61.5') from the accepted and
@@ -648,10 +641,10 @@ def _make_version_constraint(info: Dict[str, str], install: bool) -> str:
 
 
 def _do_ensure(
-    group: Dict[str, Dict[str, str]],
+    group: dict[str, dict[str, str]],
     online: bool = False,
     wheels_dir: Optional[Union[str, Path]] = None,
-) -> Optional[Tuple[str, bool]]:
+) -> Optional[tuple[str, bool]]:
     """
     Use pip to ensure we have the packages specified in @group.
 
@@ -716,7 +709,7 @@ def _do_ensure(
     return None
 
 
-def _parse_groups(file: str) -> Dict[str, Dict[str, Any]]:
+def _parse_groups(file: str) -> dict[str, dict[str, Any]]:
     if not HAVE_TOMLLIB:
         if sys.version_info < (3, 11):
             raise Ouch("found no usable tomli, please install it")
@@ -727,7 +720,7 @@ def _parse_groups(file: str) -> Dict[str, Dict[str, Any]]:
 
     # Use loads() to support both tomli v1.2.x (Ubuntu 22.04,
     # Debian bullseye-backports) and v2.0.x
-    with open(file, "r", encoding="ascii") as depfile:
+    with open(file, encoding="ascii") as depfile:
         contents = depfile.read()
         return tomllib.loads(contents)  # type: ignore
 
@@ -756,7 +749,7 @@ def ensure_group(
 
     parsed_deps = _parse_groups(file)
 
-    to_install: Dict[str, Dict[str, str]] = {}
+    to_install: dict[str, dict[str, str]] = {}
     for group in groups:
         try:
             to_install.update(parsed_deps[group])
diff --git a/python/tests/protocol.py b/python/tests/protocol.py
index e565802516d..8e2cc1edb91 100644
--- a/python/tests/protocol.py
+++ b/python/tests/protocol.py
@@ -5,7 +5,6 @@
 from tempfile import TemporaryDirectory
 
 import avocado
-
 from qemu.qmp import ConnectError, Runstate
 from qemu.qmp.protocol import AsyncProtocol, StateError
 
diff --git a/roms/edk2-build.py b/roms/edk2-build.py
index 8dc38700394..c6380b70c18 100755
--- a/roms/edk2-build.py
+++ b/roms/edk2-build.py
@@ -4,13 +4,14 @@
 https://gitlab.com/kraxel/edk2-build-config
 
 """
+import argparse
+import configparser
 import os
-import sys
-import time
 import shutil
-import argparse
 import subprocess
-import configparser
+import sys
+import time
+
 
 rebase_prefix    = ""
 version_override = None
@@ -24,16 +25,16 @@ def check_rebase():
     gitdir = '.git'
 
     if os.path.isfile(gitdir):
-        with open(gitdir, 'r', encoding = 'utf-8') as f:
+        with open(gitdir, encoding = 'utf-8') as f:
             (unused, gitdir) = f.read().split()
 
     if not os.path.exists(f'{gitdir}/rebase-merge/msgnum'):
         return
-    with open(f'{gitdir}/rebase-merge/msgnum', 'r', encoding = 'utf-8') as f:
+    with open(f'{gitdir}/rebase-merge/msgnum', encoding = 'utf-8') as f:
         msgnum = int(f.read())
-    with open(f'{gitdir}/rebase-merge/end', 'r', encoding = 'utf-8') as f:
+    with open(f'{gitdir}/rebase-merge/end', encoding = 'utf-8') as f:
         end = int(f.read())
-    with open(f'{gitdir}/rebase-merge/head-name', 'r', encoding = 'utf-8') as f:
+    with open(f'{gitdir}/rebase-merge/head-name', encoding = 'utf-8') as f:
         head = f.read().strip().split('/')
 
     rebase_prefix = f'[ {int(msgnum/2)} / {int(end/2)} - {head[-1]} ] '
diff --git a/scripts/analyse-9p-simpletrace.py b/scripts/analyse-9p-simpletrace.py
index 7dfcb6ba2f9..a5c792d660c 100755
--- a/scripts/analyse-9p-simpletrace.py
+++ b/scripts/analyse-9p-simpletrace.py
@@ -4,8 +4,10 @@
 #
 # Author: Harsh Prateek Bora
 import os
+
 import simpletrace
 
+
 symbol_9p = {
     6   : 'TLERROR',
     7   : 'RLERROR',
diff --git a/scripts/analyse-locks-simpletrace.py b/scripts/analyse-locks-simpletrace.py
index d650dd71408..bcf0973da59 100755
--- a/scripts/analyse-locks-simpletrace.py
+++ b/scripts/analyse-locks-simpletrace.py
@@ -1,14 +1,15 @@
 #!/usr/bin/env python3
-# -*- coding: utf-8 -*-
 #
 # Analyse lock events and compute statistics
 #
 # Author: Alex Bennée <alex.bennee@linaro.org>
 #
 
-import simpletrace
 import argparse
+
 import numpy as np
+import simpletrace
+
 
 class MutexAnalyser(simpletrace.Analyzer):
     "A simpletrace Analyser for checking locks."
diff --git a/scripts/analyze-migration.py b/scripts/analyze-migration.py
index 67631ac43e9..37564ca629d 100755
--- a/scripts/analyze-migration.py
+++ b/scripts/analyze-migration.py
@@ -17,12 +17,10 @@
 # You should have received a copy of the GNU Lesser General Public
 # License along with this library; if not, see <http://www.gnu.org/licenses/>.
 
-import json
-import os
 import argparse
 import collections
-import struct
-import sys
+import json
+import os
 
 
 def mkdir_p(path):
@@ -32,7 +30,7 @@ def mkdir_p(path):
         pass
 
 
-class MigrationFile(object):
+class MigrationFile:
     def __init__(self, filename):
         self.filename = filename
         self.file = open(self.filename, "rb")
@@ -106,7 +104,7 @@ def read_migration_debug_json(self):
     def close(self):
         self.file.close()
 
-class RamSection(object):
+class RamSection:
     RAM_SAVE_FLAG_COMPRESS = 0x02
     RAM_SAVE_FLAG_MEM_SIZE = 0x04
     RAM_SAVE_FLAG_PAGE     = 0x08
@@ -200,7 +198,7 @@ def read(self):
                     self.files[self.name].seek(addr, os.SEEK_SET)
                     self.files[self.name].write(data)
                 if self.dump_memory:
-                    hexdata = " ".join("{0:02x}".format(ord(c)) for c in data)
+                    hexdata = " ".join(f"{ord(c):02x}" for c in data)
                     self.memory['%s (0x%016x)' % (self.name, addr)] = hexdata
 
                 flags &= ~self.RAM_SAVE_FLAG_PAGE
@@ -224,7 +222,7 @@ def __del__(self):
                 self.files[key].close()
 
 
-class HTABSection(object):
+class HTABSection:
     HASH_PTE_SIZE_64       = 16
 
     def __init__(self, file, version_id, device, section_key):
@@ -261,7 +259,7 @@ def getDict(self):
         return ""
 
 
-class S390StorageAttributes(object):
+class S390StorageAttributes:
     STATTR_FLAG_EOS   = 0x01
     STATTR_FLAG_MORE  = 0x02
     STATTR_FLAG_ERROR = 0x04
@@ -302,7 +300,7 @@ def getDict(self):
         return ""
 
 
-class ConfigurationSection(object):
+class ConfigurationSection:
     def __init__(self, file, desc):
         self.file = file
         self.desc = desc
@@ -339,7 +337,7 @@ def read(self):
             name_len = self.file.read32()
             name = self.file.readstr(len = name_len)
 
-class VMSDFieldGeneric(object):
+class VMSDFieldGeneric:
     def __init__(self, desc, file):
         self.file = file
         self.desc = desc
@@ -349,7 +347,7 @@ def __repr__(self):
         return str(self.__str__())
 
     def __str__(self):
-        return " ".join("{0:02x}".format(c) for c in self.data)
+        return " ".join(f"{c:02x}" for c in self.data)
 
     def getDict(self):
         return self.__str__()
@@ -359,7 +357,7 @@ def read(self):
         self.data = self.file.readvar(size)
         return self.data
 
-class VMSDFieldCap(object):
+class VMSDFieldCap:
     def __init__(self, desc, file):
         self.file = file
         self.desc = desc
@@ -378,7 +376,7 @@ def read(self):
 
 class VMSDFieldInt(VMSDFieldGeneric):
     def __init__(self, desc, file):
-        super(VMSDFieldInt, self).__init__(desc, file)
+        super().__init__(desc, file)
         self.size = int(desc['size'])
         self.format = '0x%%0%dx' % (self.size * 2)
         self.sdtype = '>i%d' % self.size
@@ -397,7 +395,7 @@ def getDict(self):
         return self.__str__()
 
     def read(self):
-        super(VMSDFieldInt, self).read()
+        super().read()
         self.sdata = int.from_bytes(self.data, byteorder='big', signed=True)
         self.udata = int.from_bytes(self.data, byteorder='big', signed=False)
         self.data = self.sdata
@@ -405,23 +403,23 @@ def read(self):
 
 class VMSDFieldUInt(VMSDFieldInt):
     def __init__(self, desc, file):
-        super(VMSDFieldUInt, self).__init__(desc, file)
+        super().__init__(desc, file)
 
     def read(self):
-        super(VMSDFieldUInt, self).read()
+        super().read()
         self.data = self.udata
         return self.data
 
 class VMSDFieldIntLE(VMSDFieldInt):
     def __init__(self, desc, file):
-        super(VMSDFieldIntLE, self).__init__(desc, file)
+        super().__init__(desc, file)
         self.dtype = '<i%d' % self.size
 
 class VMSDFieldNull(VMSDFieldGeneric):
     NULL_PTR_MARKER = b'0'
 
     def __init__(self, desc, file):
-        super(VMSDFieldNull, self).__init__(desc, file)
+        super().__init__(desc, file)
 
     def __repr__(self):
         # A NULL pointer is encoded in the stream as a '0' to
@@ -435,13 +433,13 @@ def __str__(self):
         return self.__repr__()
 
     def read(self):
-        super(VMSDFieldNull, self).read()
+        super().read()
         assert(self.data == self.NULL_PTR_MARKER)
         return self.data
 
 class VMSDFieldBool(VMSDFieldGeneric):
     def __init__(self, desc, file):
-        super(VMSDFieldBool, self).__init__(desc, file)
+        super().__init__(desc, file)
 
     def __repr__(self):
         return self.data.__repr__()
@@ -453,7 +451,7 @@ def getDict(self):
         return self.data
 
     def read(self):
-        super(VMSDFieldBool, self).read()
+        super().read()
         if self.data[0] == 0:
             self.data = False
         else:
@@ -464,7 +462,7 @@ class VMSDFieldStruct(VMSDFieldGeneric):
     QEMU_VM_SUBSECTION    = 0x05
 
     def __init__(self, desc, file):
-        super(VMSDFieldStruct, self).__init__(desc, file)
+        super().__init__(desc, file)
         self.data = collections.OrderedDict()
 
         if 'fields' not in self.desc['struct']:
@@ -605,11 +603,11 @@ def __init__(self, file, version_id, device, section_key):
             self.vmsd_name = device['vmsd_name']
 
         # A section really is nothing but a FieldStruct :)
-        super(VMSDSection, self).__init__({ 'struct' : desc }, file)
+        super().__init__({ 'struct' : desc }, file)
 
 ###############################################################################
 
-class MigrationDump(object):
+class MigrationDump:
     QEMU_VM_FILE_MAGIC    = 0x5145564d
     QEMU_VM_FILE_VERSION  = 0x00000003
     QEMU_VM_EOF           = 0x00
diff --git a/scripts/block-coroutine-wrapper.py b/scripts/block-coroutine-wrapper.py
index dbbde99e39e..5207d55cb2e 100644
--- a/scripts/block-coroutine-wrapper.py
+++ b/scripts/block-coroutine-wrapper.py
@@ -23,9 +23,9 @@
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 """
 
-import sys
+from collections.abc import Iterator
 import re
-from typing import Iterator
+import sys
 
 
 def gen_header():
diff --git a/scripts/check_sparse.py b/scripts/check_sparse.py
index 29561244423..13c7beb1d8d 100644
--- a/scripts/check_sparse.py
+++ b/scripts/check_sparse.py
@@ -5,10 +5,11 @@
 # parsing
 
 import json
-import subprocess
 import os
-import sys
 import shlex
+import subprocess
+import sys
+
 
 def cmdline_for_sparse(sparse, cmdline):
     # Do not include the C compiler executable
@@ -43,7 +44,7 @@ def build_path(s):
     return s if not root_path else os.path.join(root_path, s)
 
 ccjson_path = build_path(sys.argv[1])
-with open(ccjson_path, 'r') as fd:
+with open(ccjson_path) as fd:
     compile_commands = json.load(fd)
 
 sparse = sys.argv[2:]
@@ -52,7 +53,7 @@ def build_path(s):
     cmdline = shlex.split(cmd['command'])
     cmd = cmdline_for_sparse(sparse, cmdline)
     print('REAL_CC=%s' % shlex.quote(cmdline[0]),
-          ' '.join((shlex.quote(x) for x in cmd)))
+          shlex.join(cmd))
     sparse_env['REAL_CC'] = cmdline[0]
     r = subprocess.run(cmd, env=sparse_env, cwd=root_path)
     if r.returncode != 0:
diff --git a/scripts/ci/gitlab-pipeline-status b/scripts/ci/gitlab-pipeline-status
index 39f3c22c665..ae53860bc3a 100755
--- a/scripts/ci/gitlab-pipeline-status
+++ b/scripts/ci/gitlab-pipeline-status
@@ -19,8 +19,8 @@ import http.client
 import json
 import os
 import subprocess
-import time
 import sys
+import time
 
 
 class CommunicationFailure(Exception):
@@ -40,7 +40,7 @@ def get_local_branch_commit(branch):
                             stdout=subprocess.PIPE,
                             stderr=subprocess.DEVNULL,
                             cwd=os.path.dirname(__file__),
-                            universal_newlines=True).stdout.strip()
+                            text=True).stdout.strip()
     if result == branch:
         raise ValueError("There's no local branch named '%s'" % branch)
     if len(result) != 40:
diff --git a/scripts/codeconverter/codeconverter/patching.py b/scripts/codeconverter/codeconverter/patching.py
index 9e92505d394..7c3135a3e27 100644
--- a/scripts/codeconverter/codeconverter/patching.py
+++ b/scripts/codeconverter/codeconverter/patching.py
@@ -5,16 +5,27 @@
 #
 # This work is licensed under the terms of the GNU GPL, version 2.  See
 # the COPYING file in the top-level directory.
-from typing import IO, Match, NamedTuple, Optional, Literal, Iterable, Type, Dict, List, Any, TypeVar, NewType, Tuple, Union
-from pathlib import Path
+from collections.abc import Iterable
+from io import StringIO
 from itertools import chain
-from tempfile import NamedTemporaryFile
+import logging
 import os
+from pathlib import Path
 import re
+from re import Match
 import subprocess
-from io import StringIO
+from tempfile import NamedTemporaryFile
+from typing import (
+    IO,
+    Any,
+    Literal,
+    NamedTuple,
+    Optional,
+    TypeVar,
+    Union,
+)
+
 
-import logging
 logger = logging.getLogger(__name__)
 DBG = logger.debug
 INFO = logger.info
@@ -23,6 +34,7 @@
 
 from .utils import *
 
+
 T = TypeVar('T')
 
 class Patch(NamedTuple):
@@ -104,7 +116,6 @@ def sub(self, original: str, replacement: str) -> str:
 
     def sanity_check(self) -> None:
         """Sanity check match, and print warnings if necessary"""
-        pass
 
     def replacement(self) -> Optional[str]:
         """Return replacement text for pattern, to use new code conventions"""
@@ -181,14 +192,14 @@ def domatch(klass, content: str, pos=0, endpos=-1) -> Optional[Match]:
             content = content[:endpos]
         return klass.compiled_re().match(content, pos)
 
-    def group_finditer(self, klass: Type['FileMatch'], group: Union[str, int]) -> Iterable['FileMatch']:
+    def group_finditer(self, klass: type['FileMatch'], group: Union[str, int]) -> Iterable['FileMatch']:
         assert self.file.original_content
         return (klass(self.file, m)
                 for m in klass.finditer(self.file.original_content,
                                         self.match.start(group),
                                         self.match.end(group)))
 
-    def try_group_match(self, klass: Type['FileMatch'], group: Union[str, int]) -> Optional['FileMatch']:
+    def try_group_match(self, klass: type['FileMatch'], group: Union[str, int]) -> Optional['FileMatch']:
         assert self.file.original_content
         m = klass.domatch(self.file.original_content,
                           self.match.start(group),
@@ -213,13 +224,13 @@ class FullMatch(FileMatch):
     """
     regexp = r'(?s).*' # (?s) is re.DOTALL
 
-def all_subclasses(c: Type[FileMatch]) -> Iterable[Type[FileMatch]]:
+def all_subclasses(c: type[FileMatch]) -> Iterable[type[FileMatch]]:
     for sc in c.__subclasses__():
         yield sc
         yield from all_subclasses(sc)
 
-def match_class_dict() -> Dict[str, Type[FileMatch]]:
-    d = dict((t.__name__, t) for t in all_subclasses(FileMatch))
+def match_class_dict() -> dict[str, type[FileMatch]]:
+    d = {t.__name__: t for t in all_subclasses(FileMatch)}
     return d
 
 def names(matches: Iterable[FileMatch]) -> Iterable[str]:
@@ -239,7 +250,7 @@ def apply_patches(s: str, patches: Iterable[Patch]) -> str:
     """
     r = StringIO()
     last = 0
-    def patch_sort_key(item: Tuple[int, Patch]) -> Tuple[int, int, int]:
+    def patch_sort_key(item: tuple[int, Patch]) -> tuple[int, int, int]:
         """Patches are sorted by byte position,
         patches at the same byte position are applied in the order
         they were generated.
@@ -263,22 +274,22 @@ def patch_sort_key(item: Tuple[int, Patch]) -> Tuple[int, int, int]:
 
 class RegexpScanner:
     def __init__(self) -> None:
-        self.match_index: Dict[Type[Any], List[FileMatch]] = {}
-        self.match_name_index: Dict[Tuple[Type[Any], str, str], Optional[FileMatch]] = {}
+        self.match_index: dict[type[Any], list[FileMatch]] = {}
+        self.match_name_index: dict[tuple[type[Any], str, str], Optional[FileMatch]] = {}
 
-    def _matches_of_type(self, klass: Type[Any]) -> Iterable[FileMatch]:
+    def _matches_of_type(self, klass: type[Any]) -> Iterable[FileMatch]:
         raise NotImplementedError()
 
-    def matches_of_type(self, t: Type[T]) -> List[T]:
+    def matches_of_type(self, t: type[T]) -> list[T]:
         if t not in self.match_index:
             self.match_index[t] = list(self._matches_of_type(t))
         return self.match_index[t] # type: ignore
 
-    def find_matches(self, t: Type[T], name: str, group: str='name') -> List[T]:
+    def find_matches(self, t: type[T], name: str, group: str='name') -> list[T]:
         indexkey = (t, name, group)
         if indexkey in self.match_name_index:
             return self.match_name_index[indexkey] # type: ignore
-        r: List[T] = []
+        r: list[T] = []
         for m in self.matches_of_type(t):
             assert isinstance(m, FileMatch)
             if m.getgroup(group) == name:
@@ -286,7 +297,7 @@ def find_matches(self, t: Type[T], name: str, group: str='name') -> List[T]:
         self.match_name_index[indexkey] = r # type: ignore
         return r
 
-    def find_match(self, t: Type[T], name: str, group: str='name') -> Optional[T]:
+    def find_match(self, t: type[T], name: str, group: str='name') -> Optional[T]:
         l = self.find_matches(t, name, group)
         if not l:
             return None
@@ -307,7 +318,7 @@ def __init__(self, files: 'FileList', filename: os.PathLike, force:bool=False) -
         super().__init__()
         self.allfiles = files
         self.filename = Path(filename)
-        self.patches: List[Patch] = []
+        self.patches: list[Patch] = []
         self.force = force
 
     def __repr__(self) -> str:
@@ -321,7 +332,7 @@ def line_col(self, start: int) -> LineAndColumn:
         """Return line and column for a match object inside original_content"""
         return line_col(self.original_content, start)
 
-    def _matches_of_type(self, klass: Type[Any]) -> List[FileMatch]:
+    def _matches_of_type(self, klass: type[Any]) -> list[FileMatch]:
         """Build FileMatch objects for each match of regexp"""
         if not hasattr(klass, 'regexp') or klass.regexp is None:
             return []
@@ -333,7 +344,7 @@ def _matches_of_type(self, klass: Type[Any]) -> List[FileMatch]:
             klass.__name__,' '.join(names(matches)))
         return matches
 
-    def find_match(self, t: Type[T], name: str, group: str='name') -> Optional[T]:
+    def find_match(self, t: type[T], name: str, group: str='name') -> Optional[T]:
         for m in self.matches_of_type(t):
             assert isinstance(m, FileMatch)
             if m.getgroup(group) == name:
@@ -349,7 +360,7 @@ def reset_content(self, s:str):
     def load(self) -> None:
         if self.original_content is not None:
             return
-        with open(self.filename, 'rt') as f:
+        with open(self.filename) as f:
             self.reset_content(f.read())
 
     @property
@@ -358,7 +369,7 @@ def all_matches(self) -> Iterable[FileMatch]:
         return (m for l in lists
                   for m in l)
 
-    def gen_patches(self, matches: List[FileMatch]) -> None:
+    def gen_patches(self, matches: list[FileMatch]) -> None:
         for m in matches:
             DBG("Generating patches for %r", m)
             for i,p in enumerate(m.gen_patches()):
@@ -367,7 +378,7 @@ def gen_patches(self, matches: List[FileMatch]) -> None:
                     self.line_col(p.start), self.line_col(p.end), p.replacement)
                 self.patches.append(p)
 
-    def scan_for_matches(self, class_names: Optional[List[str]]=None) -> Iterable[FileMatch]:
+    def scan_for_matches(self, class_names: Optional[list[str]]=None) -> Iterable[FileMatch]:
         DBG("class names: %r", class_names)
         class_dict = match_class_dict()
         if class_names is None:
@@ -393,7 +404,7 @@ def write_to_file(self, f: IO[str]) -> None:
         f.write(self.get_patched_content())
 
     def write_to_filename(self, filename: os.PathLike) -> None:
-        with open(filename, 'wt') as of:
+        with open(filename, 'w') as of:
             self.write_to_file(of)
 
     def patch_inplace(self) -> None:
@@ -413,7 +424,7 @@ def ref(self):
 class FileList(RegexpScanner):
     def __init__(self):
         super().__init__()
-        self.files: List[FileInfo] = []
+        self.files: list[FileInfo] = []
 
     def extend(self, *args, **kwargs):
         self.files.extend(*args, **kwargs)
@@ -421,7 +432,7 @@ def extend(self, *args, **kwargs):
     def __iter__(self):
         return iter(self.files)
 
-    def _matches_of_type(self, klass: Type[Any]) -> Iterable[FileMatch]:
+    def _matches_of_type(self, klass: type[Any]) -> Iterable[FileMatch]:
         return chain(*(f._matches_of_type(klass) for f in self.files))
 
     def find_file(self, name: str) -> Optional[FileInfo]:
@@ -432,7 +443,7 @@ def find_file(self, name: str) -> Optional[FileInfo]:
         else:
             return None
 
-    def one_pass(self, class_names: List[str]) -> int:
+    def one_pass(self, class_names: list[str]) -> int:
         total_patches = 0
         for f in self.files:
             INFO("Scanning file %s", f.filename)
@@ -448,7 +459,7 @@ def one_pass(self, class_names: List[str]) -> int:
                     logger.exception("%s: failed to patch file", f.filename)
         return total_patches
 
-    def patch_content(self, max_passes, class_names: List[str]) -> None:
+    def patch_content(self, max_passes, class_names: list[str]) -> None:
         """Multi-pass content patching loop
 
         We run multiple passes because there are rules that will
diff --git a/scripts/codeconverter/codeconverter/qom_macros.py b/scripts/codeconverter/codeconverter/qom_macros.py
index 2b0c8224a18..04512bfffdd 100644
--- a/scripts/codeconverter/codeconverter/qom_macros.py
+++ b/scripts/codeconverter/codeconverter/qom_macros.py
@@ -5,15 +5,16 @@
 #
 # This work is licensed under the terms of the GNU GPL, version 2.  See
 # the COPYING file in the top-level directory.
-import re
 from itertools import chain
+import logging
+import re
 from typing import *
 
-from .regexps import *
 from .patching import *
+from .regexps import *
 from .utils import *
 
-import logging
+
 logger = logging.getLogger(__name__)
 DBG = logger.debug
 INFO = logger.info
@@ -590,16 +591,16 @@ def gen_patches(self) -> Iterable[Patch]:
         self.debug("checker_dict: %r", checker_dict)
         for uppercase,checkers in checker_dict.items():
             fields = ('instancetype', 'classtype', 'uppercase', 'typename')
-            fvalues = dict((field, set(getattr(m, field) for m in checkers
-                                       if getattr(m, field, None) is not None))
-                            for field in fields)
+            fvalues = {field: {getattr(m, field) for m in checkers
+                                       if getattr(m, field, None) is not None}
+                            for field in fields}
             for field,values in fvalues.items():
                 if len(values) > 1:
                     for c in checkers:
                         c.warn("%s mismatch (%s)", field, ' '.join(values))
                     return
 
-            field_dict = dict((f, v.pop() if v else None) for f,v in fvalues.items())
+            field_dict = {f: v.pop() if v else None for f,v in fvalues.items()}
             yield from self.gen_patches_for_type(uppercase, checkers, field_dict)
 
     def find_conflicts(self, uppercase: str, checkers: List[TypeDeclaration]) -> bool:
diff --git a/scripts/codeconverter/codeconverter/qom_type_info.py b/scripts/codeconverter/codeconverter/qom_type_info.py
index 22a25560760..d4dd6267b76 100644
--- a/scripts/codeconverter/codeconverter/qom_type_info.py
+++ b/scripts/codeconverter/codeconverter/qom_type_info.py
@@ -6,10 +6,12 @@
 # This work is licensed under the terms of the GNU GPL, version 2.  See
 # the COPYING file in the top-level directory.
 import re
-from .regexps import *
+
 from .patching import *
-from .utils import *
 from .qom_macros import *
+from .regexps import *
+from .utils import *
+
 
 TI_FIELDS = [ 'name', 'parent', 'abstract', 'interfaces',
     'instance_size', 'instance_init', 'instance_post_init', 'instance_finalize',
@@ -89,8 +91,8 @@ def initializers(self) -> Optional[TypeInfoInitializers]:
         fields = self.group('fields')
         if fields is None:
             return None
-        d = dict((fm.group('field'), fm)
-                  for fm in self.group_finditer(FieldInitializer, 'fields'))
+        d = {fm.group('field'): fm
+                  for fm in self.group_finditer(FieldInitializer, 'fields')}
         self._initializers = d # type: ignore
         return self._initializers
 
diff --git a/scripts/codeconverter/codeconverter/regexps.py b/scripts/codeconverter/codeconverter/regexps.py
index 77993cc3b97..08657f10754 100644
--- a/scripts/codeconverter/codeconverter/regexps.py
+++ b/scripts/codeconverter/codeconverter/regexps.py
@@ -6,9 +6,10 @@
 # This work is licensed under the terms of the GNU GPL, version 2.  See
 # the COPYING file in the top-level directory.
 """Helpers for creation of regular expressions"""
-import re
-
 import logging
+import re
+
+
 logger = logging.getLogger(__name__)
 DBG = logger.debug
 INFO = logger.info
diff --git a/scripts/codeconverter/codeconverter/test_patching.py b/scripts/codeconverter/codeconverter/test_patching.py
index 71dfbd47e15..b125eee2b72 100644
--- a/scripts/codeconverter/codeconverter/test_patching.py
+++ b/scripts/codeconverter/codeconverter/test_patching.py
@@ -6,9 +6,16 @@
 # This work is licensed under the terms of the GNU GPL, version 2.  See
 # the COPYING file in the top-level directory.
 from tempfile import NamedTemporaryFile
-from .patching import FileInfo, FileMatch, Patch, FileList
+
+from .patching import (
+    FileInfo,
+    FileList,
+    FileMatch,
+    Patch,
+)
 from .regexps import *
 
+
 class BasicPattern(FileMatch):
     regexp = '[abc]{3}'
 
diff --git a/scripts/codeconverter/codeconverter/test_regexps.py b/scripts/codeconverter/codeconverter/test_regexps.py
index 4526268ae80..86d0499c50e 100644
--- a/scripts/codeconverter/codeconverter/test_regexps.py
+++ b/scripts/codeconverter/codeconverter/test_regexps.py
@@ -5,9 +5,10 @@
 #
 # This work is licensed under the terms of the GNU GPL, version 2.  See
 # the COPYING file in the top-level directory.
-from .regexps import *
 from .qom_macros import *
 from .qom_type_info import *
+from .regexps import *
+
 
 def test_res() -> None:
     def fullmatch(regexp, s):
diff --git a/scripts/codeconverter/codeconverter/utils.py b/scripts/codeconverter/codeconverter/utils.py
index 760ab7eecd2..ced81a76486 100644
--- a/scripts/codeconverter/codeconverter/utils.py
+++ b/scripts/codeconverter/codeconverter/utils.py
@@ -5,9 +5,10 @@
 #
 # This work is licensed under the terms of the GNU GPL, version 2.  See
 # the COPYING file in the top-level directory.
-from typing import *
-
 import logging
+from typing import *
+
+
 logger = logging.getLogger(__name__)
 DBG = logger.debug
 INFO = logger.info
diff --git a/scripts/codeconverter/converter.py b/scripts/codeconverter/converter.py
index 75cb515d935..984dbc2fb8f 100755
--- a/scripts/codeconverter/converter.py
+++ b/scripts/codeconverter/converter.py
@@ -9,18 +9,20 @@
 # This work is licensed under the terms of the GNU GPL, version 2.  See
 # the COPYING file in the top-level directory.
 #
-import sys
 import argparse
-import os
-import os.path
+import logging
 import re
-from typing import *
+import sys
 
-from codeconverter.patching import FileInfo, match_class_dict, FileList
+from codeconverter.patching import FileInfo, FileList, match_class_dict
 import codeconverter.qom_macros
-from codeconverter.qom_type_info import TI_FIELDS, type_infos, TypeInfoVar
+from codeconverter.qom_type_info import (
+    TI_FIELDS,
+    TypeInfoVar,
+    type_infos,
+)
+
 
-import logging
 logger = logging.getLogger(__name__)
 DBG = logger.debug
 INFO = logger.info
diff --git a/scripts/compare-machine-types.py b/scripts/compare-machine-types.py
index 2af3995eb82..ee5fd87b480 100755
--- a/scripts/compare-machine-types.py
+++ b/scripts/compare-machine-types.py
@@ -26,12 +26,15 @@
 # You should have received a copy of the GNU General Public License
 # along with this program; if not, see <http://www.gnu.org/licenses/>.
 
-import sys
+from argparse import ArgumentParser, Namespace, RawTextHelpFormatter
+from collections.abc import Generator
+from contextlib import ExitStack
 from os import path
-from argparse import ArgumentParser, RawTextHelpFormatter, Namespace
+import sys
+from typing import Any, Optional, Union
+
 import pandas as pd
-from contextlib import ExitStack
-from typing import Optional, List, Dict, Generator, Tuple, Union, Any, Set
+
 
 try:
     qemu_dir = path.abspath(path.dirname(path.dirname(__file__)))
@@ -81,7 +84,7 @@ def is_child_of(self, parent: 'Driver') -> bool:
 
         return False
 
-    def set_implementations(self, implementations: List['Driver']) -> None:
+    def set_implementations(self, implementations: list['Driver']) -> None:
         self.implementations = implementations
 
 
@@ -89,7 +92,7 @@ class QEMUObject(Driver):
     def __init__(self, vm: QEMUMachine, name: str) -> None:
         super().__init__(vm, name, True)
 
-    def set_implementations(self, implementations: List[Driver]) -> None:
+    def set_implementations(self, implementations: list[Driver]) -> None:
         self.implementations = implementations
 
         # each implementation of the abstract driver has to use property getter
@@ -105,7 +108,7 @@ def set_implementations(self, implementations: List[Driver]) -> None:
 class QEMUDevice(QEMUObject):
     def __init__(self, vm: QEMUMachine) -> None:
         super().__init__(vm, 'device')
-        self.cached: Dict[str, List[Dict[str, Any]]] = {}
+        self.cached: dict[str, list[dict[str, Any]]] = {}
 
     def get_prop(self, driver: str, prop_name: str) -> str:
         if driver not in self.cached:
@@ -121,7 +124,7 @@ def get_prop(self, driver: str, prop_name: str) -> str:
 class QEMUx86CPU(QEMUObject):
     def __init__(self, vm: QEMUMachine) -> None:
         super().__init__(vm, 'x86_64-cpu')
-        self.cached: Dict[str, Dict[str, Any]] = {}
+        self.cached: dict[str, dict[str, Any]] = {}
 
     def get_prop(self, driver: str, prop_name: str) -> str:
         if not driver.endswith('-x86_64-cpu'):
@@ -141,7 +144,7 @@ def get_prop(self, driver: str, prop_name: str) -> str:
 class QEMUMemoryBackend(QEMUObject):
     def __init__(self, vm: QEMUMachine) -> None:
         super().__init__(vm, 'memory-backend')
-        self.cached: Dict[str, List[Dict[str, Any]]] = {}
+        self.cached: dict[str, list[dict[str, Any]]] = {}
 
     def get_prop(self, driver: str, prop_name: str) -> str:
         if driver not in self.cached:
@@ -172,7 +175,7 @@ class VMPropertyGetter:
     """It implements the relationship between drivers and how to get their
     properties"""
     def __init__(self, vm: QEMUMachine) -> None:
-        self.drivers: Dict[str, Driver] = {}
+        self.drivers: dict[str, Driver] = {}
 
         qom_all_types = vm.cmd('qom-list-types', abstract=True)
         self.drivers = {t['name']: new_driver(vm, t['name'],
@@ -201,7 +204,7 @@ def get_prop(self, driver: str, prop: str) -> str:
 
         return drv.get_prop(driver, prop)
 
-    def get_implementations(self, driver: str) -> List[str]:
+    def get_implementations(self, driver: str) -> list[str]:
         return [impl.name for impl in self.drivers[driver].implementations]
 
 
@@ -211,10 +214,10 @@ class Machine:
     implementations)
     """
     # raw_mt_dict - dict produced by `query-machines`
-    def __init__(self, raw_mt_dict: Dict[str, Any],
+    def __init__(self, raw_mt_dict: dict[str, Any],
                  qemu_drivers: VMPropertyGetter) -> None:
         self.name = raw_mt_dict['name']
-        self.compat_props: Dict[str, Any] = {}
+        self.compat_props: dict[str, Any] = {}
         # properties are applied sequentially and can rewrite values like in
         # QEMU. Also it has to resolve class relationships to apply appropriate
         # values from abstract class to all implementations
@@ -239,7 +242,7 @@ class Configuration():
     """Class contains all necessary components to generate table and is used
     to compare different binaries"""
     def __init__(self, vm: QEMUMachine,
-                 req_mt: List[str], all_mt: bool) -> None:
+                 req_mt: list[str], all_mt: bool) -> None:
         self._vm = vm
         self._binary = vm.binary
         self._qemu_args = args.qemu_args.split(' ')
@@ -247,11 +250,11 @@ def __init__(self, vm: QEMUMachine,
         self._qemu_drivers = VMPropertyGetter(vm)
         self.req_mt = get_req_mt(self._qemu_drivers, vm, req_mt, all_mt)
 
-    def get_implementations(self, driver_name: str) -> List[str]:
+    def get_implementations(self, driver_name: str) -> list[str]:
         return self._qemu_drivers.get_implementations(driver_name)
 
-    def get_table(self, req_props: List[Tuple[str, str]]) -> pd.DataFrame:
-        table: List[pd.DataFrame] = []
+    def get_table(self, req_props: list[tuple[str, str]]) -> pd.DataFrame:
+        table: list[pd.DataFrame] = []
         for mt in self.req_mt:
             name = f'{self._binary}\n{mt.name}'
             column = []
@@ -339,7 +342,7 @@ def parse_args() -> Namespace:
     return parser.parse_args()
 
 
-def mt_comp(mt: Machine) -> Tuple[str, int, int, int]:
+def mt_comp(mt: Machine) -> tuple[str, int, int, int]:
     """Function to compare and sort machine by names.
     It returns socket_name, major version, minor version, revision"""
     # none, microvm, x-remote and etc.
@@ -353,7 +356,7 @@ def mt_comp(mt: Machine) -> Tuple[str, int, int, int]:
 
 
 def get_mt_definitions(qemu_drivers: VMPropertyGetter,
-                       vm: QEMUMachine) -> List[Machine]:
+                       vm: QEMUMachine) -> list[Machine]:
     """Constructs list of machine definitions (primarily compat_props) via
     info from QEMU"""
     raw_mt_defs = vm.cmd('query-machines', compat_props=True)
@@ -366,7 +369,7 @@ def get_mt_definitions(qemu_drivers: VMPropertyGetter,
 
 
 def get_req_mt(qemu_drivers: VMPropertyGetter, vm: QEMUMachine,
-               req_mt: Optional[List[str]], all_mt: bool) -> List[Machine]:
+               req_mt: Optional[list[str]], all_mt: bool) -> list[Machine]:
     """Returns list of requested by user machines"""
     mt_defs = get_mt_definitions(qemu_drivers, vm)
     if all_mt:
@@ -384,12 +387,12 @@ def get_req_mt(qemu_drivers: VMPropertyGetter, vm: QEMUMachine,
     return matched_mt
 
 
-def get_affected_props(configs: List[Configuration]) -> Generator[Tuple[str,
+def get_affected_props(configs: list[Configuration]) -> Generator[tuple[str,
                                                                         str],
                                                                   None, None]:
     """Helps to go through all affected in machine definitions drivers
     and properties"""
-    driver_props: Dict[str, Set[Any]] = {}
+    driver_props: dict[str, set[Any]] = {}
     for config in configs:
         for mt in config.req_mt:
             compat_props = mt.compat_props
@@ -437,7 +440,7 @@ def simplify_table(table: pd.DataFrame) -> pd.DataFrame:
 # driver2 | property3 |  value5  |  value6  | ...
 #   ...   |    ...    |   ...    |   ...    | ...
 #
-def fill_prop_table(configs: List[Configuration],
+def fill_prop_table(configs: list[Configuration],
                     is_raw: bool) -> pd.DataFrame:
     req_props = list(get_affected_props(configs))
     if not req_props:
diff --git a/scripts/coverage/compare_gcov_json.py b/scripts/coverage/compare_gcov_json.py
index 1b92dc2c8c3..052e29d7295 100755
--- a/scripts/coverage/compare_gcov_json.py
+++ b/scripts/coverage/compare_gcov_json.py
@@ -15,8 +15,9 @@
 
 import argparse
 import json
-import sys
 from pathlib import Path
+import sys
+
 
 def create_parser():
     parser = argparse.ArgumentParser(
@@ -55,11 +56,11 @@ def load_json(json_file_path: Path, verbose = False) -> dict[str, set[int]]:
 
         lines = filecov["lines"]
 
-        executed_lines = set(
+        executed_lines = {
             linecov["line_number"]
             for linecov in filecov["lines"]
             if linecov["count"] != 0 and not linecov["gcovr/noncode"]
-        )
+        }
 
         # if this file has any coverage add it to the system
         if len(executed_lines) > 0:
diff --git a/scripts/cpu-x86-uarch-abi.py b/scripts/cpu-x86-uarch-abi.py
index 5a052083eea..0207bd3f9c0 100644
--- a/scripts/cpu-x86-uarch-abi.py
+++ b/scripts/cpu-x86-uarch-abi.py
@@ -6,9 +6,11 @@
 # compatibility levels for each CPU model.
 #
 
-from qemu.qmp.legacy import QEMUMonitorProtocol
 import sys
 
+from qemu.qmp.legacy import QEMUMonitorProtocol
+
+
 if len(sys.argv) != 2:
     print("syntax: %s QMP-SOCK\n\n" % __file__ +
           "Where QMP-SOCK points to a QEMU process such as\n\n" +
diff --git a/scripts/decodetree.py b/scripts/decodetree.py
index e8b72da3a97..35e8da282f8 100644
--- a/scripts/decodetree.py
+++ b/scripts/decodetree.py
@@ -20,11 +20,12 @@
 # See the syntax and semantics in docs/devel/decodetree.rst.
 #
 
+import getopt
 import io
 import os
 import re
 import sys
-import getopt
+
 
 insnwidth = 32
 bitop_width = 32
@@ -87,7 +88,6 @@
 
 class CycleError(ValueError):
     """Subclass of ValueError raised if cycles exist in the graph"""
-    pass
 
 class TopologicalSorter:
     """Topologically sort a graph"""
@@ -113,7 +113,7 @@ def static_order(self):
         # Add empty dependencies where needed
         data.update({item:{} for item in extra_items_in_deps})
         while True:
-            ordered = set(item for item, dep in data.items() if not dep)
+            ordered = {item for item, dep in data.items() if not dep}
             if not ordered:
                 break
             r.extend(ordered)
@@ -1559,7 +1559,7 @@ def main():
 
     for filename in args:
         input_file = filename
-        f = open(filename, 'rt', encoding='utf-8')
+        f = open(filename, encoding='utf-8')
         parse_file(f, toppat)
         f.close()
 
@@ -1579,9 +1579,9 @@ def main():
         prop_size(stree)
 
     if output_null:
-        output_fd = open(os.devnull, 'wt', encoding='utf-8', errors="ignore")
+        output_fd = open(os.devnull, 'w', encoding='utf-8', errors="ignore")
     elif output_file:
-        output_fd = open(output_file, 'wt', encoding='utf-8')
+        output_fd = open(output_file, 'w', encoding='utf-8')
     else:
         output_fd = io.TextIOWrapper(sys.stdout.buffer,
                                      encoding=sys.stdout.encoding,
diff --git a/scripts/device-crash-test b/scripts/device-crash-test
index da8b56edd99..33496b88770 100755
--- a/scripts/device-crash-test
+++ b/scripts/device-crash-test
@@ -24,16 +24,16 @@ Run QEMU with all combinations of -machine and -device types,
 check for crashes and unexpected errors.
 """
 
-import os
-import sys
-import glob
-import logging
-import traceback
-import re
-import random
 import argparse
 from itertools import chain
+import logging
+import os
 from pathlib import Path
+import random
+import re
+import sys
+import traceback
+
 
 try:
     from qemu.machine import QEMUMachine
@@ -286,7 +286,7 @@ def infoQDM(vm):
         yield d
 
 
-class QemuBinaryInfo(object):
+class QemuBinaryInfo:
     def __init__(self, binary, devtype):
         if devtype is None:
             devtype = 'device'
@@ -303,7 +303,7 @@ class QemuBinaryInfo(object):
             self.alldevs = set(qomListTypeNames(vm, implements=devtype, abstract=False))
             # there's no way to query DeviceClass::user_creatable using QMP,
             # so use 'info qdm':
-            self.no_user_devs = set([d['name'] for d in infoQDM(vm, ) if d['no-user']])
+            self.no_user_devs = {d['name'] for d in infoQDM(vm, ) if d['no-user']}
             self.machines = list(m['name'] for m in vm.cmd('query-machines'))
             self.user_devs = self.alldevs.difference(self.no_user_devs)
             self.kvm_available = vm.cmd('query-kvm')['enabled']
diff --git a/scripts/dump-guest-memory.py b/scripts/dump-guest-memory.py
index 4177261d33d..dfeaba26032 100644
--- a/scripts/dump-guest-memory.py
+++ b/scripts/dump-guest-memory.py
@@ -16,6 +16,7 @@
 import ctypes
 import struct
 
+
 try:
     UINTPTR_T = gdb.lookup_type("uintptr_t")
 except Exception as inst:
@@ -62,7 +63,7 @@ def le32_to_cpu(val):
 def le64_to_cpu(val):
     return struct.unpack("<Q", struct.pack("=Q", val))[0]
 
-class ELF(object):
+class ELF:
     """Representation of a ELF file."""
 
     def __init__(self, arch):
@@ -501,7 +502,7 @@ class DumpGuestMemory(gdb.Command):
 shape and this command should mostly work."""
 
     def __init__(self):
-        super(DumpGuestMemory, self).__init__("dump-guest-memory",
+        super().__init__("dump-guest-memory",
                                               gdb.COMMAND_DATA,
                                               gdb.COMPLETE_FILENAME)
         self.elf = None
diff --git a/scripts/feature_to_c.py b/scripts/feature_to_c.py
index 5f8fa8ad5c6..bf15814a52e 100644
--- a/scripts/feature_to_c.py
+++ b/scripts/feature_to_c.py
@@ -1,7 +1,10 @@
 #!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-import os, sys, xml.etree.ElementTree
+import os
+import sys
+import xml.etree.ElementTree
+
 
 def writeliteral(indent, bytes):
     sys.stdout.write(' ' * indent)
diff --git a/scripts/kvm/kvm_flightrecorder b/scripts/kvm/kvm_flightrecorder
index 78ca3af9c44..2fd3fd923d4 100755
--- a/scripts/kvm/kvm_flightrecorder
+++ b/scripts/kvm/kvm_flightrecorder
@@ -32,8 +32,9 @@
 # consuming CPU cycles.  No disk I/O is performed since the ring buffer holds a
 # fixed-size in-memory trace.
 
-import sys
 import os
+import sys
+
 
 tracing_dir = '/sys/kernel/debug/tracing'
 
@@ -60,7 +61,7 @@ def stop_tracing():
     write_file(trace_path('current_tracer'), 'nop')
 
 def dump_trace():
-    tracefile = open(trace_path('trace'), 'r')
+    tracefile = open(trace_path('trace'))
     try:
         lines = True
         while lines:
@@ -71,7 +72,7 @@ def dump_trace():
 
 def tail_trace():
     try:
-        for line in open(trace_path('trace_pipe'), 'r'):
+        for line in open(trace_path('trace_pipe')):
             sys.stdout.write(line)
     except KeyboardInterrupt:
         pass
diff --git a/scripts/kvm/vmxcap b/scripts/kvm/vmxcap
index 508be19c758..c000028c1e4 100755
--- a/scripts/kvm/vmxcap
+++ b/scripts/kvm/vmxcap
@@ -26,7 +26,7 @@ MSR_IA32_VMX_VMFUNC = 0x491
 MSR_IA32_VMX_PROCBASED_CTLS3 = 0x492
 MSR_IA32_VMX_EXIT_CTLS2 = 0x493
 
-class msr(object):
+class msr:
     def __init__(self):
         try:
             self.f = open('/dev/cpu/0/msr', 'rb', 0)
@@ -40,7 +40,7 @@ class msr(object):
         except:
             return default
 
-class Control(object):
+class Control:
     def __init__(self, name, bits, cap_msr, true_cap_msr = None):
         self.name = name
         self.bits = bits
@@ -80,7 +80,7 @@ class Allowed1Control(Control):
         val = m.read(nr, 0)
         return (0, val)
 
-class Misc(object):
+class Misc:
     def __init__(self, name, bits, msr):
         self.name = name
         self.bits = bits
diff --git a/scripts/meson-buildoptions.py b/scripts/meson-buildoptions.py
index a3e22471b2f..230f2ae7b2d 100644
--- a/scripts/meson-buildoptions.py
+++ b/scripts/meson-buildoptions.py
@@ -21,9 +21,10 @@
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 
 import json
-import textwrap
 import shlex
 import sys
+import textwrap
+
 
 # Options with nonstandard names (e.g. --with/--without) or OS-dependent
 # defaults.  Try not to add any.
diff --git a/scripts/minikconf.py b/scripts/minikconf.py
index 6f7f43b2918..2a7b4faf524 100644
--- a/scripts/minikconf.py
+++ b/scripts/minikconf.py
@@ -12,9 +12,10 @@
 # the top-level directory.
 
 import os
-import sys
-import re
 import random
+import re
+import sys
+
 
 __all__ = [ 'KconfigDataError', 'KconfigParserError',
             'KconfigData', 'KconfigParser' ,
@@ -402,8 +403,8 @@ def do_include(self, include):
         if incl_abs_fname in self.data.previously_included:
             return
         try:
-            fp = open(incl_abs_fname, 'rt', encoding='utf-8')
-        except IOError as e:
+            fp = open(incl_abs_fname, encoding='utf-8')
+        except OSError as e:
             raise KconfigParserError(self,
                                 '%s: %s' % (e.strerror, include))
 
@@ -696,7 +697,7 @@ def scan_token(self):
             parser.do_assignment(name, value == 'y')
             external_vars.add(name[7:])
         else:
-            fp = open(arg, 'rt', encoding='utf-8')
+            fp = open(arg, encoding='utf-8')
             parser.parse_file(fp)
             fp.close()
 
@@ -705,7 +706,7 @@ def scan_token(self):
         if key not in external_vars and config[key]:
             print ('CONFIG_%s=y' % key)
 
-    deps = open(argv[2], 'wt', encoding='utf-8')
+    deps = open(argv[2], 'w', encoding='utf-8')
     for fname in data.previously_included:
         print ('%s: %s' % (argv[1], fname), file=deps)
     deps.close()
diff --git a/scripts/modinfo-collect.py b/scripts/modinfo-collect.py
index 48bd92bd618..28e87ca612e 100644
--- a/scripts/modinfo-collect.py
+++ b/scripts/modinfo-collect.py
@@ -1,11 +1,10 @@
 #!/usr/bin/env python3
-# -*- coding: utf-8 -*-
 
-import os
-import sys
 import json
 import shlex
 import subprocess
+import sys
+
 
 def process_command(src, command):
     skip = False
@@ -53,7 +52,7 @@ def main(args):
         cmdline = process_command(src, command)
         print("MODINFO_DEBUG cmd", cmdline)
         result = subprocess.run(cmdline, stdout = subprocess.PIPE,
-                                universal_newlines = True)
+                                text = True)
         if result.returncode != 0:
             sys.exit(result.returncode)
         for line in result.stdout.split('\n'):
diff --git a/scripts/modinfo-generate.py b/scripts/modinfo-generate.py
index b1538fcced7..f6428bc80a8 100644
--- a/scripts/modinfo-generate.py
+++ b/scripts/modinfo-generate.py
@@ -1,9 +1,9 @@
 #!/usr/bin/env python3
-# -*- coding: utf-8 -*-
 
 import os
 import sys
 
+
 def print_array(name, values):
     if len(values) == 0:
         return
@@ -109,7 +109,7 @@ def main(args):
 
     error = False
     for dep in deps.difference(modules):
-        print("Dependency {} cannot be satisfied".format(dep),
+        print(f"Dependency {dep} cannot be satisfied",
               file=sys.stderr)
         error = True
 
diff --git a/scripts/modules/module_block.py b/scripts/modules/module_block.py
index 1109df827d5..e07f61cf4bc 100644
--- a/scripts/modules/module_block.py
+++ b/scripts/modules/module_block.py
@@ -10,8 +10,9 @@
 # This work is licensed under the terms of the GNU GPL, version 2.
 # See the COPYING file in the top-level directory.
 
-import sys
 import os
+import sys
+
 
 def get_string_struct(line):
     data = line.split()
@@ -35,7 +36,7 @@ def add_module(fheader, library, format_name, protocol_name):
 
 def process_file(fheader, filename):
     # This parser assumes the coding style rules are being followed
-    with open(filename, "r") as cfile:
+    with open(filename) as cfile:
         found_start = False
         library, _ = os.path.splitext(os.path.basename(filename))
         for line in cfile:
diff --git a/scripts/mtest2make.py b/scripts/mtest2make.py
index 2ef375fc6fb..4a4b40e3062 100644
--- a/scripts/mtest2make.py
+++ b/scripts/mtest2make.py
@@ -8,10 +8,10 @@
 import itertools
 import json
 import os
-import shlex
 import sys
 
-class Suite(object):
+
+class Suite:
     def __init__(self):
         self.deps = set()
         self.speeds = ['quick']
@@ -66,8 +66,8 @@ def process_tests(test, targets, suites):
         suites[s].deps.update(deps)
 
 def emit_prolog(suites, prefix):
-    all_targets = ' '.join((f'{prefix}-{k}' for k in suites.keys()))
-    all_xml = ' '.join((f'{prefix}-report-{k}.junit.xml' for k in suites.keys()))
+    all_targets = ' '.join(f'{prefix}-{k}' for k in suites.keys())
+    all_xml = ' '.join(f'{prefix}-report-{k}.junit.xml' for k in suites.keys())
     print()
     print(f'all-{prefix}-targets = {all_targets}')
     print(f'all-{prefix}-xml = {all_xml}')
diff --git a/scripts/oss-fuzz/minimize_qtest_trace.py b/scripts/oss-fuzz/minimize_qtest_trace.py
index d1f3990c16a..2878e3ad271 100755
--- a/scripts/oss-fuzz/minimize_qtest_trace.py
+++ b/scripts/oss-fuzz/minimize_qtest_trace.py
@@ -1,15 +1,15 @@
 #!/usr/bin/env python3
-# -*- coding: utf-8 -*-
 
 """
 This takes a crashing qtest trace and tries to remove superfluous operations
 """
 
-import sys
 import os
+import struct
 import subprocess
+import sys
 import time
-import struct
+
 
 QEMU_ARGS = None
 QEMU_PATH = None
@@ -41,7 +41,7 @@ def usage():
      timing dependent instructions. Off by default.
 -M2: try setting bits in operand of write/out to zero. Off by default.
 
-""".format((sys.argv[0])))
+""".format(sys.argv[0]))
 
 deduplication_note = """\n\
 Note: While trimming the input, sometimes the mutated trace triggers a different
@@ -71,7 +71,7 @@ def check_if_trace_crashes(trace, path):
         except subprocess.TimeoutExpired:
             print("subprocess.TimeoutExpired")
             return False
-        print("Identifying Crashes by this string: {}".format(CRASH_TOKEN))
+        print(f"Identifying Crashes by this string: {CRASH_TOKEN}")
         global deduplication_note
         print(deduplication_note)
         return True
@@ -136,7 +136,7 @@ def remove_lines(newtrace, outpath):
         prior = newtrace[i:i+remove_step]
         for j in range(i, i+remove_step):
             newtrace[j] = ""
-        print("Removing {lines} ...\n".format(lines=prior))
+        print(f"Removing {prior} ...\n")
         if check_if_trace_crashes(newtrace, outpath):
             i += remove_step
             # Double the number of lines to remove for next round
@@ -247,7 +247,7 @@ def clear_bits(newtrace, outpath):
            continue
         # write ADDR SIZE DATA
         # outx ADDR VALUE
-        print("\nzero setting bits: {}".format(newtrace[i]))
+        print(f"\nzero setting bits: {newtrace[i]}")
 
         prefix = " ".join(newtrace[i].split()[:-1])
         data = newtrace[i].split()[-1]
@@ -281,9 +281,9 @@ def minimize_trace(inpath, outpath):
     if not check_if_trace_crashes(trace, outpath):
         sys.exit("The input qtest trace didn't cause a crash...")
     end = time.time()
-    print("Crashed in {} seconds".format(end-start))
+    print(f"Crashed in {end-start} seconds")
     TIMEOUT = (end-start)*5
-    print("Setting the timeout for {} seconds".format(TIMEOUT))
+    print(f"Setting the timeout for {TIMEOUT} seconds")
 
     newtrace = trace[:]
     global M1, M2
diff --git a/scripts/oss-fuzz/output_reproducer.py b/scripts/oss-fuzz/output_reproducer.py
index e8ef76b3413..96b2a18d7cc 100755
--- a/scripts/oss-fuzz/output_reproducer.py
+++ b/scripts/oss-fuzz/output_reproducer.py
@@ -1,5 +1,4 @@
 #!/usr/bin/env python3
-# -*- coding: utf-8 -*-
 
 """
 Convert plain qtest traces to C or Bash reproducers
@@ -10,11 +9,12 @@
 or similar
 """
 
-import sys
-import os
 import argparse
-import textwrap
 from datetime import date
+import os
+import sys
+import textwrap
+
 
 __author__     = "Alexander Bulekov <alxndr@bu.edu>"
 __copyright__  = "Copyright (C) 2021, Red Hat, Inc."
@@ -47,10 +47,10 @@ def c_comment(s):
 def print_c_function(s):
     print("/* ")
     for l in s.splitlines():
-        print(" * {}".format(l))
+        print(f" * {l}")
 
 def bash_reproducer(path, args, trace):
-    result = '\\\n'.join(textwrap.wrap("cat << EOF | {} {}".format(path, args),
+    result = '\\\n'.join(textwrap.wrap(f"cat << EOF | {path} {args}",
                                        72, break_on_hyphens=False,
                                        drop_whitespace=False))
     for l in trace.splitlines():
@@ -60,14 +60,14 @@ def bash_reproducer(path, args, trace):
 
 def c_reproducer(name, args, trace):
     result = []
-    result.append("""static void {}(void)\n{{""".format(name))
+    result.append(f"""static void {name}(void)\n{{""")
 
     # libqtest will add its own qtest args, so get rid of them
     args = args.replace("-accel qtest","")
     args = args.replace(",accel=qtest","")
     args = args.replace("-machine accel=qtest","")
     args = args.replace("-qtest stdio","")
-    result.append("""QTestState *s = qtest_init("{}");""".format(args))
+    result.append(f"""QTestState *s = qtest_init("{args}");""")
     for l in trace.splitlines():
         param = l.split()
         cmd = param[0]
@@ -90,7 +90,7 @@ def c_reproducer(name, args, trace):
             if len(param) ==1:
                 result.append("qtest_clock_step_next(s);")
             else:
-                result.append("qtest_clock_step(s, {});".format(param[1]))
+                result.append(f"qtest_clock_step(s, {param[1]});")
     result.append("qtest_quit(s);\n}")
     return "\n".join(result)
 
diff --git a/scripts/oss-fuzz/reorder_fuzzer_qtest_trace.py b/scripts/oss-fuzz/reorder_fuzzer_qtest_trace.py
index b154a25508f..86aab8bc941 100755
--- a/scripts/oss-fuzz/reorder_fuzzer_qtest_trace.py
+++ b/scripts/oss-fuzz/reorder_fuzzer_qtest_trace.py
@@ -1,5 +1,4 @@
 #!/usr/bin/env python3
-# -*- coding: utf-8 -*-
 
 """
 Use this to convert qtest log info from a generic fuzzer input into a qtest
@@ -64,6 +63,7 @@
 
 import sys
 
+
 __author__     = "Alexander Bulekov <alxndr@bu.edu>"
 __copyright__  = "Copyright (C) 2020, Red Hat, Inc."
 __license__    = "GPL version 2 or (at your option) any later version"
@@ -73,11 +73,11 @@
 
 
 def usage():
-    sys.exit("Usage: {} /path/to/qtest_log_output".format((sys.argv[0])))
+    sys.exit(f"Usage: {(sys.argv[0])} /path/to/qtest_log_output")
 
 
 def main(filename):
-    with open(filename, "r") as f:
+    with open(filename) as f:
         trace = f.readlines()
 
     # Leave only lines that look like logged qtest commands
diff --git a/scripts/performance/dissect.py b/scripts/performance/dissect.py
index bf24f509225..f5eff6b41aa 100755
--- a/scripts/performance/dissect.py
+++ b/scripts/performance/dissect.py
@@ -108,7 +108,7 @@ def main():
 
         # Read the callgrind_annotate output to callgrind_data[]
         callgrind_data = []
-        with open(annotate_out_path, 'r') as data:
+        with open(annotate_out_path) as data:
             callgrind_data = data.readlines()
 
         # Line number with the total number of instructions
diff --git a/scripts/performance/topN_callgrind.py b/scripts/performance/topN_callgrind.py
index f3f05fce551..d7a7d0722c9 100755
--- a/scripts/performance/topN_callgrind.py
+++ b/scripts/performance/topN_callgrind.py
@@ -83,7 +83,7 @@
 
 # Read the callgrind_annotate output to callgrind_data[]
 callgrind_data = []
-with open('/tmp/callgrind_annotate.out', 'r') as data:
+with open('/tmp/callgrind_annotate.out') as data:
     callgrind_data = data.readlines()
 
 # Line number with the total number of instructions
diff --git a/scripts/performance/topN_perf.py b/scripts/performance/topN_perf.py
index 7b19e6a7424..8470cc7f694 100755
--- a/scripts/performance/topN_perf.py
+++ b/scripts/performance/topN_perf.py
@@ -111,7 +111,7 @@
 
 # Read the reported data to functions[]
 functions = []
-with open("/tmp/perf_report.out", "r") as data:
+with open("/tmp/perf_report.out") as data:
     # Only read lines that are not comments (comments start with #)
     # Only read lines that are not empty
     functions = [line for line in data.readlines() if line and line[0]
diff --git a/scripts/probe-gdb-support.py b/scripts/probe-gdb-support.py
index 6bcadce1500..32c365a306c 100644
--- a/scripts/probe-gdb-support.py
+++ b/scripts/probe-gdb-support.py
@@ -1,5 +1,4 @@
 #!/usr/bin/env python3
-# coding: utf-8
 #
 # Probe gdb for supported architectures.
 #
@@ -19,9 +18,10 @@
 
 import argparse
 import re
-from subprocess import check_output, STDOUT, CalledProcessError
+from subprocess import STDOUT, CalledProcessError, check_output
 import sys
 
+
 # Mappings from gdb arch to QEMU target
 MAP = {
     "alpha" : ["alpha"],
diff --git a/scripts/python_qmp_updater.py b/scripts/python_qmp_updater.py
index 494a1698124..43420d88a5b 100755
--- a/scripts/python_qmp_updater.py
+++ b/scripts/python_qmp_updater.py
@@ -9,6 +9,7 @@
 import sys
 from typing import Optional
 
+
 start_reg = re.compile(r'^(?P<padding> *)(?P<res>\w+) = (?P<vm>.*).qmp\(',
                        flags=re.MULTILINE)
 
diff --git a/scripts/qapi-gen.py b/scripts/qapi-gen.py
index f3518d29a54..cdceb7f6de6 100644
--- a/scripts/qapi-gen.py
+++ b/scripts/qapi-gen.py
@@ -15,5 +15,6 @@
 
 from qapi import main
 
+
 if __name__ == '__main__':
     sys.exit(main.main())
diff --git a/scripts/qapi/commands.py b/scripts/qapi/commands.py
index 79142273828..cd3a665319a 100644
--- a/scripts/qapi/commands.py
+++ b/scripts/qapi/commands.py
@@ -13,12 +13,7 @@
 See the COPYING file in the top-level directory.
 """
 
-from typing import (
-    Dict,
-    List,
-    Optional,
-    Set,
-)
+from typing import Optional
 
 from .common import c_name, mcgen
 from .gen import (
@@ -276,7 +271,7 @@ def gen_marshal(name: str,
 
 
 def gen_register_command(name: str,
-                         features: List[QAPISchemaFeature],
+                         features: list[QAPISchemaFeature],
                          success_response: bool,
                          allow_oob: bool,
                          allow_preconfig: bool,
@@ -308,7 +303,7 @@ def __init__(self, prefix: str, gen_tracing: bool):
             prefix, 'qapi-commands',
             ' * Schema-defined QAPI/QMP commands', None, __doc__,
             gen_tracing=gen_tracing)
-        self._visited_ret_types: Dict[QAPIGenC, Set[QAPISchemaType]] = {}
+        self._visited_ret_types: dict[QAPIGenC, set[QAPISchemaType]] = {}
         self._gen_tracing = gen_tracing
 
     def _begin_user_module(self, name: str) -> None:
@@ -375,7 +370,7 @@ def visit_command(self,
                       name: str,
                       info: Optional[QAPISourceInfo],
                       ifcond: QAPISchemaIfCond,
-                      features: List[QAPISchemaFeature],
+                      features: list[QAPISchemaFeature],
                       arg_type: Optional[QAPISchemaObjectType],
                       ret_type: Optional[QAPISchemaType],
                       gen: bool,
diff --git a/scripts/qapi/common.py b/scripts/qapi/common.py
index d7c8aa3365c..d1fa5003c29 100644
--- a/scripts/qapi/common.py
+++ b/scripts/qapi/common.py
@@ -11,15 +11,10 @@
 # This work is licensed under the terms of the GNU GPL, version 2.
 # See the COPYING file in the top-level directory.
 
+from collections.abc import Sequence
 import re
-from typing import (
-    Any,
-    Dict,
-    Match,
-    Optional,
-    Sequence,
-    Union,
-)
+from re import Match
+from typing import Any, Optional, Union
 
 
 #: Magic string that gets removed along with all space to its right.
@@ -95,22 +90,22 @@ def c_name(name: str, protect: bool = True) -> str:
                     (like C keywords) by prepending ``q_``.
     """
     # ANSI X3J11/88-090, 3.1.1
-    c89_words = set(['auto', 'break', 'case', 'char', 'const', 'continue',
+    c89_words = {'auto', 'break', 'case', 'char', 'const', 'continue',
                      'default', 'do', 'double', 'else', 'enum', 'extern',
                      'float', 'for', 'goto', 'if', 'int', 'long', 'register',
                      'return', 'short', 'signed', 'sizeof', 'static',
                      'struct', 'switch', 'typedef', 'union', 'unsigned',
-                     'void', 'volatile', 'while'])
+                     'void', 'volatile', 'while'}
     # ISO/IEC 9899:1999, 6.4.1
-    c99_words = set(['inline', 'restrict', '_Bool', '_Complex', '_Imaginary'])
+    c99_words = {'inline', 'restrict', '_Bool', '_Complex', '_Imaginary'}
     # ISO/IEC 9899:2011, 6.4.1
-    c11_words = set(['_Alignas', '_Alignof', '_Atomic', '_Generic',
-                     '_Noreturn', '_Static_assert', '_Thread_local'])
+    c11_words = {'_Alignas', '_Alignof', '_Atomic', '_Generic',
+                     '_Noreturn', '_Static_assert', '_Thread_local'}
     # GCC http://gcc.gnu.org/onlinedocs/gcc-4.7.1/gcc/C-Extensions.html
     # excluding _.*
-    gcc_words = set(['asm', 'typeof'])
+    gcc_words = {'asm', 'typeof'}
     # C++ ISO/IEC 14882:2003 2.11
-    cpp_words = set(['bool', 'catch', 'class', 'const_cast', 'delete',
+    cpp_words = {'bool', 'catch', 'class', 'const_cast', 'delete',
                      'dynamic_cast', 'explicit', 'false', 'friend', 'mutable',
                      'namespace', 'new', 'operator', 'private', 'protected',
                      'public', 'reinterpret_cast', 'static_cast', 'template',
@@ -118,9 +113,9 @@ def c_name(name: str, protect: bool = True) -> str:
                      'using', 'virtual', 'wchar_t',
                      # alternative representations
                      'and', 'and_eq', 'bitand', 'bitor', 'compl', 'not',
-                     'not_eq', 'or', 'or_eq', 'xor', 'xor_eq'])
+                     'not_eq', 'or', 'or_eq', 'xor', 'xor_eq'}
     # namespace pollution:
-    polluted_words = set(['unix', 'errno', 'mips', 'sparc', 'i386', 'linux'])
+    polluted_words = {'unix', 'errno', 'mips', 'sparc', 'i386', 'linux'}
     name = re.sub(r'[^A-Za-z0-9_]', '_', name)
     if protect and (name in (c89_words | c99_words | c11_words | gcc_words
                              | cpp_words | polluted_words)
@@ -139,7 +134,7 @@ def __init__(self, initial: int = 0) -> None:
         self._level = initial
 
     def __repr__(self) -> str:
-        return "{}({:d})".format(type(self).__name__, self._level)
+        return f"{type(self).__name__}({self._level:d})"
 
     def __str__(self) -> str:
         """Return the current indentation as a string of spaces."""
@@ -199,11 +194,11 @@ def guardend(name: str) -> str:
                  name=c_fname(name).upper())
 
 
-def gen_ifcond(ifcond: Optional[Union[str, Dict[str, Any]]],
+def gen_ifcond(ifcond: Optional[Union[str, dict[str, Any]]],
                cond_fmt: str, not_fmt: str,
                all_operator: str, any_operator: str) -> str:
 
-    def do_gen(ifcond: Union[str, Dict[str, Any]],
+    def do_gen(ifcond: Union[str, dict[str, Any]],
                need_parens: bool) -> str:
         if isinstance(ifcond, str):
             return cond_fmt % ifcond
@@ -226,11 +221,11 @@ def gen_infix(operator: str, operands: Sequence[Any]) -> str:
     return do_gen(ifcond, False)
 
 
-def cgen_ifcond(ifcond: Optional[Union[str, Dict[str, Any]]]) -> str:
+def cgen_ifcond(ifcond: Optional[Union[str, dict[str, Any]]]) -> str:
     return gen_ifcond(ifcond, 'defined(%s)', '!%s', ' && ', ' || ')
 
 
-def docgen_ifcond(ifcond: Optional[Union[str, Dict[str, Any]]]) -> str:
+def docgen_ifcond(ifcond: Optional[Union[str, dict[str, Any]]]) -> str:
     # TODO Doc generated for conditions needs polish
     return gen_ifcond(ifcond, '%s', 'not %s', ' and ', ' or ')
 
diff --git a/scripts/qapi/error.py b/scripts/qapi/error.py
index e35e4ddb26a..2e249ba5366 100644
--- a/scripts/qapi/error.py
+++ b/scripts/qapi/error.py
@@ -1,4 +1,3 @@
-# -*- coding: utf-8 -*-
 #
 # Copyright (c) 2017-2019 Red Hat Inc.
 #
diff --git a/scripts/qapi/events.py b/scripts/qapi/events.py
index d179b0ed695..8584d69f33a 100644
--- a/scripts/qapi/events.py
+++ b/scripts/qapi/events.py
@@ -12,7 +12,7 @@
 See the COPYING file in the top-level directory.
 """
 
-from typing import List, Optional
+from typing import Optional
 
 from .common import c_enum_const, c_name, mcgen
 from .gen import QAPISchemaModularCVisitor, build_params, ifcontext
@@ -80,7 +80,7 @@ def gen_param_var(typ: QAPISchemaObjectType) -> str:
 
 def gen_event_send(name: str,
                    arg_type: Optional[QAPISchemaObjectType],
-                   features: List[QAPISchemaFeature],
+                   features: list[QAPISchemaFeature],
                    boxed: bool,
                    event_enum_name: str,
                    event_emit: str) -> str:
@@ -180,7 +180,7 @@ def __init__(self, prefix: str):
             prefix, 'qapi-events',
             ' * Schema-defined QAPI/QMP events', None, __doc__)
         self._event_enum_name = c_name(prefix + 'QAPIEvent', protect=False)
-        self._event_enum_members: List[QAPISchemaEnumMember] = []
+        self._event_enum_members: list[QAPISchemaEnumMember] = []
         self._event_emit_name = c_name(prefix + 'qapi_event_emit')
 
     def _begin_user_module(self, name: str) -> None:
@@ -230,7 +230,7 @@ def visit_event(self,
                     name: str,
                     info: Optional[QAPISourceInfo],
                     ifcond: QAPISchemaIfCond,
-                    features: List[QAPISchemaFeature],
+                    features: list[QAPISchemaFeature],
                     arg_type: Optional[QAPISchemaObjectType],
                     boxed: bool) -> None:
         with ifcontext(ifcond, self._genh, self._genc):
diff --git a/scripts/qapi/expr.py b/scripts/qapi/expr.py
index cae0a083591..46d6f4bb8ac 100644
--- a/scripts/qapi/expr.py
+++ b/scripts/qapi/expr.py
@@ -1,4 +1,3 @@
-# -*- coding: utf-8 -*-
 #
 # Copyright IBM, Corp. 2011
 # Copyright (c) 2013-2021 Red Hat Inc.
@@ -31,15 +30,9 @@
 structures and contextual semantic validation.
 """
 
+from collections.abc import Iterable
 import re
-from typing import (
-    Dict,
-    Iterable,
-    List,
-    Optional,
-    Union,
-    cast,
-)
+from typing import Optional, Union, cast
 
 from .common import c_name
 from .error import QAPISemError
@@ -183,11 +176,11 @@ def check_defn_name_str(name: str, info: QAPISourceInfo, meta: str) -> None:
                 info, "%s name should not end in 'List'" % meta)
 
 
-def check_keys(value: Dict[str, object],
+def check_keys(value: dict[str, object],
                info: QAPISourceInfo,
                source: str,
-               required: List[str],
-               optional: List[str]) -> None:
+               required: list[str],
+               optional: list[str]) -> None:
     """
     Ensure that a dict has a specific set of keys.
 
@@ -247,7 +240,7 @@ def check_flags(expr: QAPIExpression) -> None:
             expr.info, "flags 'allow-oob' and 'coroutine' are incompatible")
 
 
-def check_if(expr: Dict[str, object],
+def check_if(expr: dict[str, object],
              info: QAPISourceInfo, source: str) -> None:
     """
     Validate the ``if`` member of an object.
@@ -592,7 +585,7 @@ def check_event(expr: QAPIExpression) -> None:
         check_type_name_or_implicit(args, expr.info, "'data'", None)
 
 
-def check_exprs(exprs: List[QAPIExpression]) -> List[QAPIExpression]:
+def check_exprs(exprs: list[QAPIExpression]) -> list[QAPIExpression]:
     """
     Validate and normalize a list of parsed QAPI schema expressions.
 
diff --git a/scripts/qapi/features.py b/scripts/qapi/features.py
index 57563207a82..d605c9609da 100644
--- a/scripts/qapi/features.py
+++ b/scripts/qapi/features.py
@@ -7,7 +7,7 @@
 # See the COPYING file in the top-level directory.
 """
 
-from typing import ValuesView
+from collections.abc import ValuesView
 
 from .common import c_enum_const, c_name
 from .gen import QAPISchemaMonolithicCVisitor
diff --git a/scripts/qapi/gen.py b/scripts/qapi/gen.py
index d3c56d45c89..2a56e54aabd 100644
--- a/scripts/qapi/gen.py
+++ b/scripts/qapi/gen.py
@@ -1,4 +1,3 @@
-# -*- coding: utf-8 -*-
 #
 # QAPI code generation
 #
@@ -11,17 +10,12 @@
 # This work is licensed under the terms of the GNU GPL, version 2.
 # See the COPYING file in the top-level directory.
 
+from collections.abc import Iterator, Sequence
 from contextlib import contextmanager
 import os
 import re
 import sys
-from typing import (
-    Dict,
-    Iterator,
-    Optional,
-    Sequence,
-    Tuple,
-)
+from typing import Optional
 
 from .common import (
     c_enum_const,
@@ -136,7 +130,7 @@ def build_params(arg_type: Optional[QAPISchemaObjectType],
 class QAPIGenCCode(QAPIGen):
     def __init__(self, fname: str):
         super().__init__(fname)
-        self._start_if: Optional[Tuple[QAPISchemaIfCond, str, str]] = None
+        self._start_if: Optional[tuple[QAPISchemaIfCond, str, str]] = None
 
     def start_if(self, ifcond: QAPISchemaIfCond) -> None:
         assert self._start_if is None
@@ -264,7 +258,7 @@ def __init__(self,
         self._builtin_blurb = builtin_blurb
         self._pydoc = pydoc
         self._current_module: Optional[str] = None
-        self._module: Dict[str, Tuple[QAPIGenC, QAPIGenH,
+        self._module: dict[str, tuple[QAPIGenC, QAPIGenH,
                                       Optional[QAPIGenTrace]]] = {}
         self._main_module: Optional[str] = None
         self._gen_tracing = gen_tracing
diff --git a/scripts/qapi/introspect.py b/scripts/qapi/introspect.py
index 89ee5d5f176..0fe7387f415 100644
--- a/scripts/qapi/introspect.py
+++ b/scripts/qapi/introspect.py
@@ -11,14 +11,12 @@
 See the COPYING file in the top-level directory.
 """
 
+from collections.abc import Sequence
 from dataclasses import dataclass
 from typing import (
     Any,
-    Dict,
     Generic,
-    List,
     Optional,
-    Sequence,
     TypeVar,
     Union,
 )
@@ -61,7 +59,7 @@
 # mark the imprecision in the type model where we'd otherwise use JSONValue.
 _Stub = Any
 _Scalar = Union[str, bool, None]
-_NonScalar = Union[Dict[str, _Stub], List[_Stub]]
+_NonScalar = Union[dict[str, _Stub], list[_Stub]]
 _Value = Union[_Scalar, _NonScalar]
 JSONValue = Union[_Value, 'Annotated[_Value]']
 
@@ -69,12 +67,12 @@
 # lack precise types for them here. Python 3.6 does not offer
 # TypedDict constructs, so they are broadly typed here as simple
 # Python Dicts.
-SchemaInfo = Dict[str, object]
-SchemaInfoEnumMember = Dict[str, object]
-SchemaInfoObject = Dict[str, object]
-SchemaInfoObjectVariant = Dict[str, object]
-SchemaInfoObjectMember = Dict[str, object]
-SchemaInfoCommand = Dict[str, object]
+SchemaInfo = dict[str, object]
+SchemaInfoEnumMember = dict[str, object]
+SchemaInfoObject = dict[str, object]
+SchemaInfoObjectVariant = dict[str, object]
+SchemaInfoObjectMember = dict[str, object]
+SchemaInfoCommand = dict[str, object]
 
 
 _ValueT = TypeVar('_ValueT', bound=_Value)
@@ -175,9 +173,9 @@ def __init__(self, prefix: str, unmask: bool):
             ' * QAPI/QMP schema introspection', __doc__)
         self._unmask = unmask
         self._schema: Optional[QAPISchema] = None
-        self._trees: List[Annotated[SchemaInfo]] = []
-        self._used_types: List[QAPISchemaType] = []
-        self._name_map: Dict[str, str] = {}
+        self._trees: list[Annotated[SchemaInfo]] = []
+        self._used_types: list[QAPISchemaType] = []
+        self._name_map: dict[str, str] = {}
         self._genc.add(mcgen('''
 #include "qemu/osdep.h"
 #include "%(prefix)sqapi-introspect.h"
@@ -248,10 +246,10 @@ def _use_type(self, typ: QAPISchemaType) -> str:
 
     @staticmethod
     def _gen_features(features: Sequence[QAPISchemaFeature]
-                      ) -> List[Annotated[str]]:
+                      ) -> list[Annotated[str]]:
         return [Annotated(f.name, f.ifcond) for f in features]
 
-    def _gen_tree(self, name: str, mtype: str, obj: Dict[str, object],
+    def _gen_tree(self, name: str, mtype: str, obj: dict[str, object],
                   ifcond: QAPISchemaIfCond = QAPISchemaIfCond(),
                   features: Sequence[QAPISchemaFeature] = ()) -> None:
         """
@@ -313,8 +311,8 @@ def visit_builtin_type(self, name: str, info: Optional[QAPISourceInfo],
 
     def visit_enum_type(self, name: str, info: Optional[QAPISourceInfo],
                         ifcond: QAPISchemaIfCond,
-                        features: List[QAPISchemaFeature],
-                        members: List[QAPISchemaEnumMember],
+                        features: list[QAPISchemaFeature],
+                        members: list[QAPISchemaEnumMember],
                         prefix: Optional[str]) -> None:
         self._gen_tree(
             name, 'enum',
@@ -332,8 +330,8 @@ def visit_array_type(self, name: str, info: Optional[QAPISourceInfo],
 
     def visit_object_type_flat(self, name: str, info: Optional[QAPISourceInfo],
                                ifcond: QAPISchemaIfCond,
-                               features: List[QAPISchemaFeature],
-                               members: List[QAPISchemaObjectTypeMember],
+                               features: list[QAPISchemaFeature],
+                               members: list[QAPISchemaObjectTypeMember],
                                branches: Optional[QAPISchemaBranches]) -> None:
         obj: SchemaInfoObject = {
             'members': [self._gen_object_member(m) for m in members]
@@ -345,7 +343,7 @@ def visit_object_type_flat(self, name: str, info: Optional[QAPISourceInfo],
 
     def visit_alternate_type(self, name: str, info: Optional[QAPISourceInfo],
                              ifcond: QAPISchemaIfCond,
-                             features: List[QAPISchemaFeature],
+                             features: list[QAPISchemaFeature],
                              alternatives: QAPISchemaAlternatives) -> None:
         self._gen_tree(
             name, 'alternate',
@@ -357,7 +355,7 @@ def visit_alternate_type(self, name: str, info: Optional[QAPISourceInfo],
 
     def visit_command(self, name: str, info: Optional[QAPISourceInfo],
                       ifcond: QAPISchemaIfCond,
-                      features: List[QAPISchemaFeature],
+                      features: list[QAPISchemaFeature],
                       arg_type: Optional[QAPISchemaObjectType],
                       ret_type: Optional[QAPISchemaType], gen: bool,
                       success_response: bool, boxed: bool, allow_oob: bool,
@@ -376,7 +374,7 @@ def visit_command(self, name: str, info: Optional[QAPISourceInfo],
 
     def visit_event(self, name: str, info: Optional[QAPISourceInfo],
                     ifcond: QAPISchemaIfCond,
-                    features: List[QAPISchemaFeature],
+                    features: list[QAPISchemaFeature],
                     arg_type: Optional[QAPISchemaObjectType],
                     boxed: bool) -> None:
         assert self._schema is not None
diff --git a/scripts/qapi/parser.py b/scripts/qapi/parser.py
index 949d9e8bff7..4be74320a81 100644
--- a/scripts/qapi/parser.py
+++ b/scripts/qapi/parser.py
@@ -1,4 +1,3 @@
-# -*- coding: utf-8 -*-
 #
 # QAPI schema parser
 #
@@ -14,18 +13,15 @@
 # This work is licensed under the terms of the GNU GPL, version 2.
 # See the COPYING file in the top-level directory.
 
+from collections.abc import Mapping
 import enum
 import os
 import re
+from re import Match
 from typing import (
     TYPE_CHECKING,
     Any,
-    Dict,
-    List,
-    Mapping,
-    Match,
     Optional,
-    Set,
     Union,
 )
 
@@ -41,10 +37,10 @@
 
 
 # Return value alias for get_expr().
-_ExprValue = Union[List[object], Dict[str, object], str, bool]
+_ExprValue = Union[list[object], dict[str, object], str, bool]
 
 
-class QAPIExpression(Dict[str, Any]):
+class QAPIExpression(dict[str, Any]):
     # pylint: disable=too-few-public-methods
     def __init__(self,
                  data: Mapping[str, object],
@@ -91,7 +87,7 @@ class QAPISchemaParser:
     """
     def __init__(self,
                  fname: str,
-                 previously_included: Optional[Set[str]] = None,
+                 previously_included: Optional[set[str]] = None,
                  incl_info: Optional[QAPISourceInfo] = None):
         self._fname = fname
         self._included = previously_included or set()
@@ -107,8 +103,8 @@ def __init__(self,
         self.line_pos = 0
 
         # Parser output:
-        self.exprs: List[QAPIExpression] = []
-        self.docs: List[QAPIDoc] = []
+        self.exprs: list[QAPIExpression] = []
+        self.docs: list[QAPIDoc] = []
 
         # Showtime!
         self._parse()
@@ -122,7 +118,7 @@ def _parse(self) -> None:
         cur_doc = None
 
         # May raise OSError; allow the caller to handle it.
-        with open(self._fname, 'r', encoding='utf-8') as fp:
+        with open(self._fname, encoding='utf-8') as fp:
             self.src = fp.read()
         if self.src == '' or self.src[-1] != '\n':
             self.src += '\n'
@@ -195,7 +191,7 @@ def reject_expr_doc(doc: Optional['QAPIDoc']) -> None:
     def _include(include: str,
                  info: QAPISourceInfo,
                  incl_fname: str,
-                 previously_included: Set[str]
+                 previously_included: set[str]
                  ) -> Optional['QAPISchemaParser']:
         incl_abs_fname = os.path.abspath(incl_fname)
         # catch inclusion cycle
@@ -220,7 +216,7 @@ def _include(include: str,
     @staticmethod
     def _pragma(name: str, value: object, info: QAPISourceInfo) -> None:
 
-        def check_list_str(name: str, value: object) -> List[str]:
+        def check_list_str(name: str, value: object) -> list[str]:
             if (not isinstance(value, list) or
                     any(not isinstance(elt, str) for elt in value)):
                 raise QAPISemError(
@@ -354,8 +350,8 @@ def accept(self, skip_comment: bool = True) -> None:
                                    self.src[self.cursor-1:])
                 raise QAPIParseError(self, "stray '%s'" % match.group(0))
 
-    def get_members(self) -> Dict[str, object]:
-        expr: Dict[str, object] = {}
+    def get_members(self) -> dict[str, object]:
+        expr: dict[str, object] = {}
         if self.tok == '}':
             self.accept()
             return expr
@@ -381,8 +377,8 @@ def get_members(self) -> Dict[str, object]:
             if self.tok != "'":
                 raise QAPIParseError(self, "expected string")
 
-    def get_values(self) -> List[object]:
-        expr: List[object] = []
+    def get_values(self) -> list[object]:
+        expr: list[object] = []
         if self.tok == ']':
             self.accept()
             return expr
@@ -694,21 +690,21 @@ def __init__(self, info: QAPISourceInfo, symbol: Optional[str] = None):
         # definition doc's symbol, None for free-form doc
         self.symbol: Optional[str] = symbol
         # the sections in textual order
-        self.all_sections: List[QAPIDoc.Section] = [
+        self.all_sections: list[QAPIDoc.Section] = [
             QAPIDoc.Section(info, QAPIDoc.Kind.PLAIN)
         ]
         # the body section
         self.body: Optional[QAPIDoc.Section] = self.all_sections[0]
         # dicts mapping parameter/feature names to their description
-        self.args: Dict[str, QAPIDoc.ArgSection] = {}
-        self.features: Dict[str, QAPIDoc.ArgSection] = {}
+        self.args: dict[str, QAPIDoc.ArgSection] = {}
+        self.features: dict[str, QAPIDoc.ArgSection] = {}
         # a command's "Returns" and "Errors" section
         self.returns: Optional[QAPIDoc.Section] = None
         self.errors: Optional[QAPIDoc.Section] = None
         # "Since" section
         self.since: Optional[QAPIDoc.Section] = None
         # sections other than .body, .args, .features
-        self.sections: List[QAPIDoc.Section] = []
+        self.sections: list[QAPIDoc.Section] = []
 
     def end(self) -> None:
         for section in self.all_sections:
@@ -763,7 +759,7 @@ def _new_description(
         info: QAPISourceInfo,
         name: str,
         kind: 'QAPIDoc.Kind',
-        desc: Dict[str, ArgSection]
+        desc: dict[str, ArgSection]
     ) -> None:
         if not name:
             raise QAPISemError(info, "invalid parameter name")
@@ -834,7 +830,7 @@ def check_expr(self, expr: QAPIExpression) -> None:
     def check(self) -> None:
 
         def check_args_section(
-                args: Dict[str, QAPIDoc.ArgSection], what: str
+                args: dict[str, QAPIDoc.ArgSection], what: str
         ) -> None:
             bogus = [name for name, section in args.items()
                      if not section.member]
diff --git a/scripts/qapi/schema.py b/scripts/qapi/schema.py
index cbe3b5aa91e..4b115075077 100644
--- a/scripts/qapi/schema.py
+++ b/scripts/qapi/schema.py
@@ -1,4 +1,3 @@
-# -*- coding: utf-8 -*-
 #
 # QAPI schema internal representation
 #
@@ -19,18 +18,10 @@
 from __future__ import annotations
 
 from abc import ABC, abstractmethod
+from collections.abc import ValuesView
 import os
 import re
-from typing import (
-    Any,
-    Callable,
-    Dict,
-    List,
-    Optional,
-    Union,
-    ValuesView,
-    cast,
-)
+from typing import Any, Callable, cast
 
 from .common import (
     POINTER_SUFFIX,
@@ -49,7 +40,7 @@
 class QAPISchemaIfCond:
     def __init__(
         self,
-        ifcond: Optional[Union[str, Dict[str, object]]] = None,
+        ifcond: str | dict[str, object] | None = None,
     ) -> None:
         self.ifcond = ifcond
 
@@ -76,8 +67,8 @@ class QAPISchemaEntity:
     This is either a directive, such as include, or a definition.
     The latter uses sub-class `QAPISchemaDefinition`.
     """
-    def __init__(self, info: Optional[QAPISourceInfo]):
-        self._module: Optional[QAPISchemaModule] = None
+    def __init__(self, info: QAPISourceInfo | None):
+        self._module: QAPISchemaModule | None = None
         # For explicitly defined entities, info points to the (explicit)
         # definition.  For builtins (and their arrays), info is None.
         # For implicitly defined entities, info points to a place that
@@ -93,11 +84,11 @@ def check(self, schema: QAPISchema) -> None:
         # pylint: disable=unused-argument
         self._checked = True
 
-    def connect_doc(self, doc: Optional[QAPIDoc] = None) -> None:
+    def connect_doc(self, doc: QAPIDoc | None = None) -> None:
         pass
 
     def _set_module(
-        self, schema: QAPISchema, info: Optional[QAPISourceInfo]
+        self, schema: QAPISchema, info: QAPISourceInfo | None
     ) -> None:
         assert self._checked
         fname = info.fname if info else QAPISchemaModule.BUILTIN_MODULE_NAME
@@ -118,10 +109,10 @@ class QAPISchemaDefinition(QAPISchemaEntity):
     def __init__(
         self,
         name: str,
-        info: Optional[QAPISourceInfo],
-        doc: Optional[QAPIDoc],
-        ifcond: Optional[QAPISchemaIfCond] = None,
-        features: Optional[List[QAPISchemaFeature]] = None,
+        info: QAPISourceInfo | None,
+        doc: QAPIDoc | None,
+        ifcond: QAPISchemaIfCond | None = None,
+        features: list[QAPISchemaFeature] | None = None,
     ):
         super().__init__(info)
         for f in features or []:
@@ -141,11 +132,11 @@ def c_name(self) -> str:
     def check(self, schema: QAPISchema) -> None:
         assert not self._checked
         super().check(schema)
-        seen: Dict[str, QAPISchemaMember] = {}
+        seen: dict[str, QAPISchemaMember] = {}
         for f in self.features:
             f.check_clash(self.info, seen)
 
-    def connect_doc(self, doc: Optional[QAPIDoc] = None) -> None:
+    def connect_doc(self, doc: QAPIDoc | None = None) -> None:
         super().connect_doc(doc)
         doc = doc or self.doc
         if doc:
@@ -179,29 +170,29 @@ def visit_needed(self, entity: QAPISchemaEntity) -> bool:
         # Default to visiting everything
         return True
 
-    def visit_include(self, name: str, info: Optional[QAPISourceInfo]) -> None:
+    def visit_include(self, name: str, info: QAPISourceInfo | None) -> None:
         pass
 
     def visit_builtin_type(
-        self, name: str, info: Optional[QAPISourceInfo], json_type: str
+        self, name: str, info: QAPISourceInfo | None, json_type: str
     ) -> None:
         pass
 
     def visit_enum_type(
         self,
         name: str,
-        info: Optional[QAPISourceInfo],
+        info: QAPISourceInfo | None,
         ifcond: QAPISchemaIfCond,
-        features: List[QAPISchemaFeature],
-        members: List[QAPISchemaEnumMember],
-        prefix: Optional[str],
+        features: list[QAPISchemaFeature],
+        members: list[QAPISchemaEnumMember],
+        prefix: str | None,
     ) -> None:
         pass
 
     def visit_array_type(
         self,
         name: str,
-        info: Optional[QAPISourceInfo],
+        info: QAPISourceInfo | None,
         ifcond: QAPISchemaIfCond,
         element_type: QAPISchemaType,
     ) -> None:
@@ -210,32 +201,32 @@ def visit_array_type(
     def visit_object_type(
         self,
         name: str,
-        info: Optional[QAPISourceInfo],
+        info: QAPISourceInfo | None,
         ifcond: QAPISchemaIfCond,
-        features: List[QAPISchemaFeature],
-        base: Optional[QAPISchemaObjectType],
-        members: List[QAPISchemaObjectTypeMember],
-        branches: Optional[QAPISchemaBranches],
+        features: list[QAPISchemaFeature],
+        base: QAPISchemaObjectType | None,
+        members: list[QAPISchemaObjectTypeMember],
+        branches: QAPISchemaBranches | None,
     ) -> None:
         pass
 
     def visit_object_type_flat(
         self,
         name: str,
-        info: Optional[QAPISourceInfo],
+        info: QAPISourceInfo | None,
         ifcond: QAPISchemaIfCond,
-        features: List[QAPISchemaFeature],
-        members: List[QAPISchemaObjectTypeMember],
-        branches: Optional[QAPISchemaBranches],
+        features: list[QAPISchemaFeature],
+        members: list[QAPISchemaObjectTypeMember],
+        branches: QAPISchemaBranches | None,
     ) -> None:
         pass
 
     def visit_alternate_type(
         self,
         name: str,
-        info: Optional[QAPISourceInfo],
+        info: QAPISourceInfo | None,
         ifcond: QAPISchemaIfCond,
-        features: List[QAPISchemaFeature],
+        features: list[QAPISchemaFeature],
         alternatives: QAPISchemaAlternatives,
     ) -> None:
         pass
@@ -243,11 +234,11 @@ def visit_alternate_type(
     def visit_command(
         self,
         name: str,
-        info: Optional[QAPISourceInfo],
+        info: QAPISourceInfo | None,
         ifcond: QAPISchemaIfCond,
-        features: List[QAPISchemaFeature],
-        arg_type: Optional[QAPISchemaObjectType],
-        ret_type: Optional[QAPISchemaType],
+        features: list[QAPISchemaFeature],
+        arg_type: QAPISchemaObjectType | None,
+        ret_type: QAPISchemaType | None,
         gen: bool,
         success_response: bool,
         boxed: bool,
@@ -260,10 +251,10 @@ def visit_command(
     def visit_event(
         self,
         name: str,
-        info: Optional[QAPISourceInfo],
+        info: QAPISourceInfo | None,
         ifcond: QAPISchemaIfCond,
-        features: List[QAPISchemaFeature],
-        arg_type: Optional[QAPISchemaObjectType],
+        features: list[QAPISchemaFeature],
+        arg_type: QAPISchemaObjectType | None,
         boxed: bool,
     ) -> None:
         pass
@@ -275,7 +266,7 @@ class QAPISchemaModule:
 
     def __init__(self, name: str):
         self.name = name
-        self._entity_list: List[QAPISchemaEntity] = []
+        self._entity_list: list[QAPISchemaEntity] = []
 
     @staticmethod
     def is_system_module(name: str) -> bool:
@@ -343,7 +334,7 @@ def c_unboxed_type(self) -> str:
     def json_type(self) -> str:
         pass
 
-    def alternate_qtype(self) -> Optional[str]:
+    def alternate_qtype(self) -> str | None:
         json2qtype = {
             'null':    'QTYPE_QNULL',
             'string':  'QTYPE_QSTRING',
@@ -355,7 +346,7 @@ def alternate_qtype(self) -> Optional[str]:
         }
         return json2qtype.get(self.json_type())
 
-    def doc_type(self) -> Optional[str]:
+    def doc_type(self) -> str | None:
         if self.is_implicit():
             return None
         return self.name
@@ -415,12 +406,12 @@ class QAPISchemaEnumType(QAPISchemaType):
     def __init__(
         self,
         name: str,
-        info: Optional[QAPISourceInfo],
-        doc: Optional[QAPIDoc],
-        ifcond: Optional[QAPISchemaIfCond],
-        features: Optional[List[QAPISchemaFeature]],
-        members: List[QAPISchemaEnumMember],
-        prefix: Optional[str],
+        info: QAPISourceInfo | None,
+        doc: QAPIDoc | None,
+        ifcond: QAPISchemaIfCond | None,
+        features: list[QAPISchemaFeature] | None,
+        members: list[QAPISchemaEnumMember],
+        prefix: str | None,
     ):
         super().__init__(name, info, doc, ifcond, features)
         for m in members:
@@ -430,11 +421,11 @@ def __init__(
 
     def check(self, schema: QAPISchema) -> None:
         super().check(schema)
-        seen: Dict[str, QAPISchemaMember] = {}
+        seen: dict[str, QAPISchemaMember] = {}
         for m in self.members:
             m.check_clash(self.info, seen)
 
-    def connect_doc(self, doc: Optional[QAPIDoc] = None) -> None:
+    def connect_doc(self, doc: QAPIDoc | None = None) -> None:
         super().connect_doc(doc)
         doc = doc or self.doc
         for m in self.members:
@@ -447,7 +438,7 @@ def is_implicit(self) -> bool:
     def c_type(self) -> str:
         return c_name(self.name)
 
-    def member_names(self) -> List[str]:
+    def member_names(self) -> list[str]:
         return [m.name for m in self.members]
 
     def json_type(self) -> str:
@@ -464,7 +455,7 @@ class QAPISchemaArrayType(QAPISchemaType):
     meta = 'array'
 
     def __init__(
-        self, name: str, info: Optional[QAPISourceInfo], element_type: str
+        self, name: str, info: QAPISourceInfo | None, element_type: str
     ):
         super().__init__(name, info, None)
         self._element_type_name = element_type
@@ -499,7 +490,7 @@ def c_type(self) -> str:
     def json_type(self) -> str:
         return 'array'
 
-    def doc_type(self) -> Optional[str]:
+    def doc_type(self) -> str | None:
         elt_doc_type = self.element_type.doc_type()
         if not elt_doc_type:
             return None
@@ -518,13 +509,13 @@ class QAPISchemaObjectType(QAPISchemaType):
     def __init__(
         self,
         name: str,
-        info: Optional[QAPISourceInfo],
-        doc: Optional[QAPIDoc],
-        ifcond: Optional[QAPISchemaIfCond],
-        features: Optional[List[QAPISchemaFeature]],
-        base: Optional[str],
-        local_members: List[QAPISchemaObjectTypeMember],
-        branches: Optional[QAPISchemaBranches],
+        info: QAPISourceInfo | None,
+        doc: QAPIDoc | None,
+        ifcond: QAPISchemaIfCond | None,
+        features: list[QAPISchemaFeature] | None,
+        base: str | None,
+        local_members: list[QAPISchemaObjectTypeMember],
+        branches: QAPISchemaBranches | None,
     ):
         # struct has local_members, optional base, and no branches
         # union has base, branches, and no local_members
@@ -538,7 +529,7 @@ def __init__(
         self.base = None
         self.local_members = local_members
         self.branches = branches
-        self.members: List[QAPISchemaObjectTypeMember]
+        self.members: list[QAPISchemaObjectTypeMember]
         self._check_complete = False
 
     def check(self, schema: QAPISchema) -> None:
@@ -575,7 +566,7 @@ def check(self, schema: QAPISchema) -> None:
         # self.check_clash() works in terms of the supertype, but
         # self.members is declared List[QAPISchemaObjectTypeMember].
         # Cast down to the subtype.
-        members = cast(List[QAPISchemaObjectTypeMember], list(seen.values()))
+        members = cast(list[QAPISchemaObjectTypeMember], list(seen.values()))
 
         if self.branches:
             self.branches.check(schema, seen)
@@ -589,8 +580,8 @@ def check(self, schema: QAPISchema) -> None:
     # on behalf of info, which is not necessarily self.info
     def check_clash(
         self,
-        info: Optional[QAPISourceInfo],
-        seen: Dict[str, QAPISchemaMember],
+        info: QAPISourceInfo | None,
+        seen: dict[str, QAPISchemaMember],
     ) -> None:
         assert self._checked
         for m in self.members:
@@ -598,7 +589,7 @@ def check_clash(
         if self.branches:
             self.branches.check_clash(info, seen)
 
-    def connect_doc(self, doc: Optional[QAPIDoc] = None) -> None:
+    def connect_doc(self, doc: QAPIDoc | None = None) -> None:
         super().connect_doc(doc)
         doc = doc or self.doc
         if self.base and self.base.is_implicit():
@@ -648,9 +639,9 @@ def __init__(
         self,
         name: str,
         info: QAPISourceInfo,
-        doc: Optional[QAPIDoc],
-        ifcond: Optional[QAPISchemaIfCond],
-        features: List[QAPISchemaFeature],
+        doc: QAPIDoc | None,
+        ifcond: QAPISchemaIfCond | None,
+        features: list[QAPISchemaFeature],
         alternatives: QAPISchemaAlternatives,
     ):
         super().__init__(name, info, doc, ifcond, features)
@@ -667,8 +658,8 @@ def check(self, schema: QAPISchema) -> None:
         self.alternatives.check(schema, {})
         # Alternate branch names have no relation to the tag enum values;
         # so we have to check for potential name collisions ourselves.
-        seen: Dict[str, QAPISchemaMember] = {}
-        types_seen: Dict[str, str] = {}
+        seen: dict[str, QAPISchemaMember] = {}
+        types_seen: dict[str, str] = {}
         for v in self.alternatives.variants:
             v.check_clash(self.info, seen)
             qtype = v.type.alternate_qtype()
@@ -677,7 +668,7 @@ def check(self, schema: QAPISchema) -> None:
                     self.info,
                     "%s cannot use %s"
                     % (v.describe(self.info), v.type.describe()))
-            conflicting = set([qtype])
+            conflicting = {qtype}
             if qtype == 'QTYPE_QSTRING':
                 if isinstance(v.type, QAPISchemaEnumType):
                     for m in v.type.members:
@@ -697,7 +688,7 @@ def check(self, schema: QAPISchema) -> None:
                         % (v.describe(self.info), types_seen[qt]))
                 types_seen[qt] = v.name
 
-    def connect_doc(self, doc: Optional[QAPIDoc] = None) -> None:
+    def connect_doc(self, doc: QAPIDoc | None = None) -> None:
         super().connect_doc(doc)
         doc = doc or self.doc
         for v in self.alternatives.variants:
@@ -720,7 +711,7 @@ class QAPISchemaVariants:
     def __init__(
         self,
         info: QAPISourceInfo,
-        variants: List[QAPISchemaVariant],
+        variants: list[QAPISchemaVariant],
     ):
         self.info = info
         self.tag_member: QAPISchemaObjectTypeMember
@@ -732,7 +723,7 @@ def set_defined_in(self, name: str) -> None:
 
     # pylint: disable=unused-argument
     def check(
-            self, schema: QAPISchema, seen: Dict[str, QAPISchemaMember]
+            self, schema: QAPISchema, seen: dict[str, QAPISchemaMember]
     ) -> None:
         for v in self.variants:
             v.check(schema)
@@ -741,13 +732,13 @@ def check(
 class QAPISchemaBranches(QAPISchemaVariants):
     def __init__(self,
                  info: QAPISourceInfo,
-                 variants: List[QAPISchemaVariant],
+                 variants: list[QAPISchemaVariant],
                  tag_name: str):
         super().__init__(info, variants)
         self._tag_name = tag_name
 
     def check(
-            self, schema: QAPISchema, seen: Dict[str, QAPISchemaMember]
+            self, schema: QAPISchema, seen: dict[str, QAPISchemaMember]
     ) -> None:
         # We need to narrow the member type:
         tag_member = seen.get(c_name(self._tag_name))
@@ -814,8 +805,8 @@ def check(
 
     def check_clash(
         self,
-        info: Optional[QAPISourceInfo],
-        seen: Dict[str, QAPISchemaMember],
+        info: QAPISourceInfo | None,
+        seen: dict[str, QAPISchemaMember],
     ) -> None:
         for v in self.variants:
             # Reset seen map for each variant, since qapi names from one
@@ -829,13 +820,13 @@ def check_clash(
 class QAPISchemaAlternatives(QAPISchemaVariants):
     def __init__(self,
                  info: QAPISourceInfo,
-                 variants: List[QAPISchemaVariant],
+                 variants: list[QAPISchemaVariant],
                  tag_member: QAPISchemaObjectTypeMember):
         super().__init__(info, variants)
         self.tag_member = tag_member
 
     def check(
-            self, schema: QAPISchema, seen: Dict[str, QAPISchemaMember]
+            self, schema: QAPISchema, seen: dict[str, QAPISchemaMember]
     ) -> None:
         super().check(schema, seen)
         assert isinstance(self.tag_member.type, QAPISchemaEnumType)
@@ -850,13 +841,13 @@ class QAPISchemaMember:
     def __init__(
         self,
         name: str,
-        info: Optional[QAPISourceInfo],
-        ifcond: Optional[QAPISchemaIfCond] = None,
+        info: QAPISourceInfo | None,
+        ifcond: QAPISchemaIfCond | None = None,
     ):
         self.name = name
         self.info = info
         self.ifcond = ifcond or QAPISchemaIfCond()
-        self.defined_in: Optional[str] = None
+        self.defined_in: str | None = None
 
     def set_defined_in(self, name: str) -> None:
         assert not self.defined_in
@@ -864,8 +855,8 @@ def set_defined_in(self, name: str) -> None:
 
     def check_clash(
         self,
-        info: Optional[QAPISourceInfo],
-        seen: Dict[str, QAPISchemaMember],
+        info: QAPISourceInfo | None,
+        seen: dict[str, QAPISchemaMember],
     ) -> None:
         cname = c_name(self.name)
         if cname in seen:
@@ -875,11 +866,11 @@ def check_clash(
                 % (self.describe(info), seen[cname].describe(info)))
         seen[cname] = self
 
-    def connect_doc(self, doc: Optional[QAPIDoc]) -> None:
+    def connect_doc(self, doc: QAPIDoc | None) -> None:
         if doc:
             doc.connect_member(self)
 
-    def describe(self, info: Optional[QAPISourceInfo]) -> str:
+    def describe(self, info: QAPISourceInfo | None) -> str:
         role = self.role
         meta = 'type'
         defined_in = self.defined_in
@@ -914,16 +905,16 @@ class QAPISchemaEnumMember(QAPISchemaMember):
     def __init__(
         self,
         name: str,
-        info: Optional[QAPISourceInfo],
-        ifcond: Optional[QAPISchemaIfCond] = None,
-        features: Optional[List[QAPISchemaFeature]] = None,
+        info: QAPISourceInfo | None,
+        ifcond: QAPISchemaIfCond | None = None,
+        features: list[QAPISchemaFeature] | None = None,
     ):
         super().__init__(name, info, ifcond)
         for f in features or []:
             f.set_defined_in(name)
         self.features = features or []
 
-    def connect_doc(self, doc: Optional[QAPIDoc]) -> None:
+    def connect_doc(self, doc: QAPIDoc | None) -> None:
         super().connect_doc(doc)
         if doc:
             for f in self.features:
@@ -947,8 +938,8 @@ def __init__(
         info: QAPISourceInfo,
         typ: str,
         optional: bool,
-        ifcond: Optional[QAPISchemaIfCond] = None,
-        features: Optional[List[QAPISchemaFeature]] = None,
+        ifcond: QAPISchemaIfCond | None = None,
+        features: list[QAPISchemaFeature] | None = None,
     ):
         super().__init__(name, info, ifcond)
         for f in features or []:
@@ -965,11 +956,11 @@ def check(self, schema: QAPISchema) -> None:
         assert self.defined_in
         self.type = schema.resolve_type(self._type_name, self.info,
                                         self.describe)
-        seen: Dict[str, QAPISchemaMember] = {}
+        seen: dict[str, QAPISchemaMember] = {}
         for f in self.features:
             f.check_clash(self.info, seen)
 
-    def connect_doc(self, doc: Optional[QAPIDoc]) -> None:
+    def connect_doc(self, doc: QAPIDoc | None) -> None:
         super().connect_doc(doc)
         if doc:
             for f in self.features:
@@ -996,11 +987,11 @@ def __init__(
         self,
         name: str,
         info: QAPISourceInfo,
-        doc: Optional[QAPIDoc],
+        doc: QAPIDoc | None,
         ifcond: QAPISchemaIfCond,
-        features: List[QAPISchemaFeature],
-        arg_type: Optional[str],
-        ret_type: Optional[str],
+        features: list[QAPISchemaFeature],
+        arg_type: str | None,
+        ret_type: str | None,
         gen: bool,
         success_response: bool,
         boxed: bool,
@@ -1010,9 +1001,9 @@ def __init__(
     ):
         super().__init__(name, info, doc, ifcond, features)
         self._arg_type_name = arg_type
-        self.arg_type: Optional[QAPISchemaObjectType] = None
+        self.arg_type: QAPISchemaObjectType | None = None
         self._ret_type_name = ret_type
-        self.ret_type: Optional[QAPISchemaType] = None
+        self.ret_type: QAPISchemaType | None = None
         self.gen = gen
         self.success_response = success_response
         self.boxed = boxed
@@ -1055,7 +1046,7 @@ def check(self, schema: QAPISchema) -> None:
                         "command's 'returns' cannot take %s"
                         % self.ret_type.describe())
 
-    def connect_doc(self, doc: Optional[QAPIDoc] = None) -> None:
+    def connect_doc(self, doc: QAPIDoc | None = None) -> None:
         super().connect_doc(doc)
         doc = doc or self.doc
         if doc:
@@ -1078,15 +1069,15 @@ def __init__(
         self,
         name: str,
         info: QAPISourceInfo,
-        doc: Optional[QAPIDoc],
+        doc: QAPIDoc | None,
         ifcond: QAPISchemaIfCond,
-        features: List[QAPISchemaFeature],
-        arg_type: Optional[str],
+        features: list[QAPISchemaFeature],
+        arg_type: str | None,
         boxed: bool,
     ):
         super().__init__(name, info, doc, ifcond, features)
         self._arg_type_name = arg_type
-        self.arg_type: Optional[QAPISchemaObjectType] = None
+        self.arg_type: QAPISchemaObjectType | None = None
         self.boxed = boxed
 
     def check(self, schema: QAPISchema) -> None:
@@ -1111,7 +1102,7 @@ def check(self, schema: QAPISchema) -> None:
                     self.info,
                     "conditional event arguments require 'boxed': true")
 
-    def connect_doc(self, doc: Optional[QAPIDoc] = None) -> None:
+    def connect_doc(self, doc: QAPIDoc | None = None) -> None:
         super().connect_doc(doc)
         doc = doc or self.doc
         if doc:
@@ -1138,12 +1129,12 @@ def __init__(self, fname: str):
 
         exprs = check_exprs(parser.exprs)
         self.docs = parser.docs
-        self._entity_list: List[QAPISchemaEntity] = []
-        self._entity_dict: Dict[str, QAPISchemaDefinition] = {}
-        self._module_dict: Dict[str, QAPISchemaModule] = {}
+        self._entity_list: list[QAPISchemaEntity] = []
+        self._entity_dict: dict[str, QAPISchemaDefinition] = {}
+        self._module_dict: dict[str, QAPISchemaModule] = {}
         # NB, values in the dict will identify the first encountered
         # usage of a named feature only
-        self._feature_dict: Dict[str, QAPISchemaFeature] = {}
+        self._feature_dict: dict[str, QAPISchemaFeature] = {}
 
         # All schemas get the names defined in the QapiSpecialFeature enum.
         # Rely on dict iteration order matching insertion order so that
@@ -1183,10 +1174,10 @@ def _def_definition(self, defn: QAPISchemaDefinition) -> None:
                 defn.info, "%s is already defined" % other_defn.describe())
         self._entity_dict[defn.name] = defn
 
-    def lookup_entity(self, name: str) -> Optional[QAPISchemaEntity]:
+    def lookup_entity(self, name: str) -> QAPISchemaEntity | None:
         return self._entity_dict.get(name)
 
-    def lookup_type(self, name: str) -> Optional[QAPISchemaType]:
+    def lookup_type(self, name: str) -> QAPISchemaType | None:
         typ = self.lookup_entity(name)
         if isinstance(typ, QAPISchemaType):
             return typ
@@ -1195,8 +1186,8 @@ def lookup_type(self, name: str) -> Optional[QAPISchemaType]:
     def resolve_type(
         self,
         name: str,
-        info: Optional[QAPISourceInfo],
-        what: Union[None, str, Callable[[QAPISourceInfo], str]],
+        info: QAPISourceInfo | None,
+        what: None | str | Callable[[QAPISourceInfo], str],
     ) -> QAPISchemaType:
         typ = self.lookup_type(name)
         if not typ:
@@ -1269,9 +1260,9 @@ def _def_predefineds(self) -> None:
 
     def _make_features(
         self,
-        features: Optional[List[Dict[str, Any]]],
-        info: Optional[QAPISourceInfo],
-    ) -> List[QAPISchemaFeature]:
+        features: list[dict[str, Any]] | None,
+        info: QAPISourceInfo | None,
+    ) -> list[QAPISchemaFeature]:
         if features is None:
             return []
 
@@ -1287,23 +1278,23 @@ def _make_features(
     def _make_enum_member(
         self,
         name: str,
-        ifcond: Optional[Union[str, Dict[str, Any]]],
-        features: Optional[List[Dict[str, Any]]],
-        info: Optional[QAPISourceInfo],
+        ifcond: str | dict[str, Any] | None,
+        features: list[dict[str, Any]] | None,
+        info: QAPISourceInfo | None,
     ) -> QAPISchemaEnumMember:
         return QAPISchemaEnumMember(name, info,
                                     QAPISchemaIfCond(ifcond),
                                     self._make_features(features, info))
 
     def _make_enum_members(
-        self, values: List[Dict[str, Any]], info: Optional[QAPISourceInfo]
-    ) -> List[QAPISchemaEnumMember]:
+        self, values: list[dict[str, Any]], info: QAPISourceInfo | None
+    ) -> list[QAPISchemaEnumMember]:
         return [self._make_enum_member(v['name'], v.get('if'),
                                        v.get('features'), info)
                 for v in values]
 
     def _make_array_type(
-        self, element_type: str, info: Optional[QAPISourceInfo]
+        self, element_type: str, info: QAPISourceInfo | None
     ) -> str:
         name = element_type + 'List'    # reserved by check_defn_name_str()
         if not self.lookup_type(name):
@@ -1317,8 +1308,8 @@ def _make_implicit_object_type(
         info: QAPISourceInfo,
         ifcond: QAPISchemaIfCond,
         role: str,
-        members: List[QAPISchemaObjectTypeMember],
-    ) -> Optional[str]:
+        members: list[QAPISchemaObjectTypeMember],
+    ) -> str | None:
         if not members:
             return None
         # See also QAPISchemaObjectTypeMember.describe()
@@ -1348,9 +1339,9 @@ def _def_enum_type(self, expr: QAPIExpression) -> None:
     def _make_member(
         self,
         name: str,
-        typ: Union[List[str], str],
+        typ: list[str] | str,
         ifcond: QAPISchemaIfCond,
-        features: Optional[List[Dict[str, Any]]],
+        features: list[dict[str, Any]] | None,
         info: QAPISourceInfo,
     ) -> QAPISchemaObjectTypeMember:
         optional = False
@@ -1365,9 +1356,9 @@ def _make_member(
 
     def _make_members(
         self,
-        data: Dict[str, Any],
+        data: dict[str, Any],
         info: QAPISourceInfo,
-    ) -> List[QAPISchemaObjectTypeMember]:
+    ) -> list[QAPISchemaObjectTypeMember]:
         return [self._make_member(key, value['type'],
                                   QAPISchemaIfCond(value.get('if')),
                                   value.get('features'), info)
@@ -1415,7 +1406,7 @@ def _def_union_type(self, expr: QAPIExpression) -> None:
                                QAPISchemaIfCond(value.get('if')),
                                info)
             for (key, value) in data.items()]
-        members: List[QAPISchemaObjectTypeMember] = []
+        members: list[QAPISchemaObjectTypeMember] = []
         self._def_definition(
             QAPISchemaObjectType(name, info, expr.doc, ifcond, features,
                                  base, members,
@@ -1479,7 +1470,7 @@ def _def_event(self, expr: QAPIExpression) -> None:
         self._def_definition(QAPISchemaEvent(name, info, expr.doc, ifcond,
                                              features, data, boxed))
 
-    def _def_exprs(self, exprs: List[QAPIExpression]) -> None:
+    def _def_exprs(self, exprs: list[QAPIExpression]) -> None:
         for expr in exprs:
             if 'enum' in expr:
                 self._def_enum_type(expr)
diff --git a/scripts/qapi/source.py b/scripts/qapi/source.py
index ffdc3f482ac..960fe58a5ff 100644
--- a/scripts/qapi/source.py
+++ b/scripts/qapi/source.py
@@ -10,7 +10,7 @@
 # See the COPYING file in the top-level directory.
 
 import copy
-from typing import List, Optional, TypeVar
+from typing import Optional, TypeVar
 
 
 class QAPISchemaPragma:
@@ -21,13 +21,13 @@ def __init__(self) -> None:
         # Are documentation comments required?
         self.doc_required = False
         # Commands whose names may use '_'
-        self.command_name_exceptions: List[str] = []
+        self.command_name_exceptions: list[str] = []
         # Commands allowed to return a non-dictionary
-        self.command_returns_exceptions: List[str] = []
+        self.command_returns_exceptions: list[str] = []
         # Types, commands, and events with undocumented members
-        self.documentation_exceptions: List[str] = []
+        self.documentation_exceptions: list[str] = []
         # Types whose member names may violate case conventions
-        self.member_name_exceptions: List[str] = []
+        self.member_name_exceptions: list[str] = []
 
 
 class QAPISourceInfo:
diff --git a/scripts/qapi/types.py b/scripts/qapi/types.py
index 2bf75338283..ad84e68b488 100644
--- a/scripts/qapi/types.py
+++ b/scripts/qapi/types.py
@@ -13,7 +13,7 @@
 # See the COPYING file in the top-level directory.
 """
 
-from typing import List, Optional
+from typing import Optional
 
 from .common import c_enum_const, c_name, mcgen
 from .gen import QAPISchemaModularCVisitor, gen_features, ifcontext
@@ -38,7 +38,7 @@
 
 
 def gen_enum_lookup(name: str,
-                    members: List[QAPISchemaEnumMember],
+                    members: list[QAPISchemaEnumMember],
                     prefix: Optional[str] = None) -> str:
     max_index = c_enum_const(name, '_MAX', prefix)
     feats = ''
@@ -82,7 +82,7 @@ def gen_enum_lookup(name: str,
 
 
 def gen_enum(name: str,
-             members: List[QAPISchemaEnumMember],
+             members: list[QAPISchemaEnumMember],
              prefix: Optional[str] = None) -> str:
     # append automatically generated _MAX value
     enum_members = members + [QAPISchemaEnumMember('_MAX', None)]
@@ -136,7 +136,7 @@ def gen_array(name: str, element_type: QAPISchemaType) -> str:
                  c_name=c_name(name), c_type=element_type.c_type())
 
 
-def gen_struct_members(members: List[QAPISchemaObjectTypeMember]) -> str:
+def gen_struct_members(members: list[QAPISchemaObjectTypeMember]) -> str:
     ret = ''
     for memb in members:
         ret += memb.ifcond.gen_if()
@@ -155,7 +155,7 @@ def gen_struct_members(members: List[QAPISchemaObjectTypeMember]) -> str:
 
 def gen_object(name: str, ifcond: QAPISchemaIfCond,
                base: Optional[QAPISchemaObjectType],
-               members: List[QAPISchemaObjectTypeMember],
+               members: list[QAPISchemaObjectTypeMember],
                variants: Optional[QAPISchemaVariants]) -> str:
     if name in objects_seen:
         return ''
@@ -325,8 +325,8 @@ def visit_enum_type(self,
                         name: str,
                         info: Optional[QAPISourceInfo],
                         ifcond: QAPISchemaIfCond,
-                        features: List[QAPISchemaFeature],
-                        members: List[QAPISchemaEnumMember],
+                        features: list[QAPISchemaFeature],
+                        members: list[QAPISchemaEnumMember],
                         prefix: Optional[str]) -> None:
         with ifcontext(ifcond, self._genh, self._genc):
             self._genh.preamble_add(gen_enum(name, members, prefix))
@@ -346,9 +346,9 @@ def visit_object_type(self,
                           name: str,
                           info: Optional[QAPISourceInfo],
                           ifcond: QAPISchemaIfCond,
-                          features: List[QAPISchemaFeature],
+                          features: list[QAPISchemaFeature],
                           base: Optional[QAPISchemaObjectType],
-                          members: List[QAPISchemaObjectTypeMember],
+                          members: list[QAPISchemaObjectTypeMember],
                           branches: Optional[QAPISchemaBranches]) -> None:
         # Nothing to do for the special empty builtin
         if name == 'q_empty':
@@ -369,7 +369,7 @@ def visit_alternate_type(self,
                              name: str,
                              info: Optional[QAPISourceInfo],
                              ifcond: QAPISchemaIfCond,
-                             features: List[QAPISchemaFeature],
+                             features: list[QAPISchemaFeature],
                              alternatives: QAPISchemaAlternatives) -> None:
         with ifcontext(ifcond, self._genh):
             self._genh.preamble_add(gen_fwd_object_or_array(name))
diff --git a/scripts/qapi/visit.py b/scripts/qapi/visit.py
index 36e240967b6..a0221fe5ab8 100644
--- a/scripts/qapi/visit.py
+++ b/scripts/qapi/visit.py
@@ -13,7 +13,7 @@
 See the COPYING file in the top-level directory.
 """
 
-from typing import List, Optional
+from typing import Optional
 
 from .common import (
     c_enum_const,
@@ -59,7 +59,7 @@ def gen_visit_members_decl(name: str) -> str:
 
 def gen_visit_object_members(name: str,
                              base: Optional[QAPISchemaObjectType],
-                             members: List[QAPISchemaObjectTypeMember],
+                             members: list[QAPISchemaObjectTypeMember],
                              branches: Optional[QAPISchemaBranches]) -> str:
     ret = mcgen('''
 
@@ -370,8 +370,8 @@ def visit_enum_type(self,
                         name: str,
                         info: Optional[QAPISourceInfo],
                         ifcond: QAPISchemaIfCond,
-                        features: List[QAPISchemaFeature],
-                        members: List[QAPISchemaEnumMember],
+                        features: list[QAPISchemaFeature],
+                        members: list[QAPISchemaEnumMember],
                         prefix: Optional[str]) -> None:
         with ifcontext(ifcond, self._genh, self._genc):
             self._genh.add(gen_visit_decl(name, scalar=True))
@@ -390,9 +390,9 @@ def visit_object_type(self,
                           name: str,
                           info: Optional[QAPISourceInfo],
                           ifcond: QAPISchemaIfCond,
-                          features: List[QAPISchemaFeature],
+                          features: list[QAPISchemaFeature],
                           base: Optional[QAPISchemaObjectType],
-                          members: List[QAPISchemaObjectTypeMember],
+                          members: list[QAPISchemaObjectTypeMember],
                           branches: Optional[QAPISchemaBranches]) -> None:
         # Nothing to do for the special empty builtin
         if name == 'q_empty':
@@ -412,7 +412,7 @@ def visit_alternate_type(self,
                              name: str,
                              info: Optional[QAPISourceInfo],
                              ifcond: QAPISchemaIfCond,
-                             features: List[QAPISchemaFeature],
+                             features: list[QAPISchemaFeature],
                              alternatives: QAPISchemaAlternatives) -> None:
         with ifcontext(ifcond, self._genh, self._genc):
             self._genh.add(gen_visit_decl(name))
diff --git a/scripts/qcow2-to-stdout.py b/scripts/qcow2-to-stdout.py
index 06b7c13ccbb..d758eb7882e 100755
--- a/scripts/qcow2-to-stdout.py
+++ b/scripts/qcow2-to-stdout.py
@@ -25,6 +25,7 @@
 # refcount tables and L1 tables when referring to those clusters.
 
 import argparse
+from contextlib import contextmanager
 import errno
 import math
 import os
@@ -34,7 +35,7 @@
 import sys
 import tempfile
 import time
-from contextlib import contextmanager
+
 
 QCOW2_DEFAULT_CLUSTER_SIZE = 65536
 QCOW2_DEFAULT_REFCOUNT_BITS = 16
@@ -74,8 +75,7 @@ def clusters_with_data(fd, cluster_size):
         try:
             data_from = os.lseek(fd, data_to, os.SEEK_DATA)
             data_to = align_up(os.lseek(fd, data_from, os.SEEK_HOLE), cluster_size)
-            for idx in range(data_from // cluster_size, data_to // cluster_size):
-                yield idx
+            yield from range(data_from // cluster_size, data_to // cluster_size)
         except OSError as err:
             if err.errno == errno.ENXIO:  # End of file reached
                 break
@@ -113,7 +113,7 @@ def get_input_as_raw_file(input_file, input_format):
         # Kill the storage daemon on exit
         # and remove all temporary files
         if os.path.exists(pid_file):
-            with open(pid_file, "r") as f:
+            with open(pid_file) as f:
                 pid = int(f.readline())
             os.kill(pid, signal.SIGTERM)
             while os.path.exists(pid_file):
diff --git a/scripts/qemu-gdb.py b/scripts/qemu-gdb.py
index cfae94a2e90..f707d5f6de2 100644
--- a/scripts/qemu-gdb.py
+++ b/scripts/qemu-gdb.py
@@ -14,16 +14,25 @@
 # At the (gdb) prompt, type "source scripts/qemu-gdb.py".
 # "help qemu" should then list the supported QEMU debug support commands.
 
+import os
+import sys
+
 import gdb
 
-import os, sys
 
 # Annoyingly, gdb doesn't put the directory of scripts onto the
 # module search path. Do it manually.
 
 sys.path.append(os.path.dirname(__file__))
 
-from qemugdb import aio, mtree, coroutine, tcg, timers
+from qemugdb import (
+    aio,
+    coroutine,
+    mtree,
+    tcg,
+    timers,
+)
+
 
 class QemuCommand(gdb.Command):
     '''Prefix for QEMU debug support commands'''
diff --git a/scripts/qemu-plugin-symbols.py b/scripts/qemu-plugin-symbols.py
index e285ebb8f9e..c00dc05bd7c 100755
--- a/scripts/qemu-plugin-symbols.py
+++ b/scripts/qemu-plugin-symbols.py
@@ -1,5 +1,4 @@
 #!/usr/bin/env python3
-# -*- coding: utf-8 -*-
 #
 # Extract QEMU Plugin API symbols from a header file
 #
@@ -15,6 +14,7 @@
 import argparse
 import re
 
+
 def extract_symbols(plugin_header):
     with open(plugin_header) as file:
         content = file.read()
@@ -38,7 +38,7 @@ def main() -> None:
 
     print('{')
     for s in syms:
-        print("  {};".format(s))
+        print(f"  {s};")
     print('};')
 
 if __name__ == '__main__':
diff --git a/scripts/qemu-stamp.py b/scripts/qemu-stamp.py
index 7beeeb07edd..73e2bac1741 100644
--- a/scripts/qemu-stamp.py
+++ b/scripts/qemu-stamp.py
@@ -5,6 +5,7 @@
 import os
 import sys
 
+
 sha = hashlib.sha1()
 is_file = False
 for arg in sys.argv[1:]:
diff --git a/scripts/qemu-trace-stap b/scripts/qemu-trace-stap
index e983460ee75..e0482ee3dc9 100755
--- a/scripts/qemu-trace-stap
+++ b/scripts/qemu-trace-stap
@@ -19,7 +19,6 @@
 # along with this program; if not, see <http://www.gnu.org/licenses/>.
 
 import argparse
-import copy
 import os.path
 import re
 import subprocess
diff --git a/scripts/qemugdb/aio.py b/scripts/qemugdb/aio.py
index d7c1ba0c286..316ac26d14b 100644
--- a/scripts/qemugdb/aio.py
+++ b/scripts/qemugdb/aio.py
@@ -12,6 +12,7 @@
 import gdb
 from qemugdb import coroutine
 
+
 def isnull(ptr):
     return ptr == gdb.Value(0).cast(ptr.type)
 
diff --git a/scripts/qemugdb/coroutine.py b/scripts/qemugdb/coroutine.py
index e98fc48a4b2..e2b2924f29a 100644
--- a/scripts/qemugdb/coroutine.py
+++ b/scripts/qemugdb/coroutine.py
@@ -11,6 +11,7 @@
 
 import gdb
 
+
 VOID_PTR = gdb.lookup_type('void').pointer()
 
 def pthread_self():
diff --git a/scripts/qemugdb/mtree.py b/scripts/qemugdb/mtree.py
index 8fe42c3c12d..a6507016ebf 100644
--- a/scripts/qemugdb/mtree.py
+++ b/scripts/qemugdb/mtree.py
@@ -13,6 +13,7 @@
 
 import gdb
 
+
 def isnull(ptr):
     return ptr == gdb.Value(0).cast(ptr.type)
 
diff --git a/scripts/qemugdb/tcg.py b/scripts/qemugdb/tcg.py
index 16c03c06a94..9e27f5730b4 100644
--- a/scripts/qemugdb/tcg.py
+++ b/scripts/qemugdb/tcg.py
@@ -1,4 +1,3 @@
-# -*- coding: utf-8 -*-
 #
 # GDB debugging support, TCG status
 #
@@ -14,6 +13,7 @@
 
 import gdb
 
+
 class TCGLockStatusCommand(gdb.Command):
     '''Display TCG Execution Status'''
     def __init__(self):
diff --git a/scripts/qemugdb/timers.py b/scripts/qemugdb/timers.py
index 46537b27cf0..77acba990a8 100644
--- a/scripts/qemugdb/timers.py
+++ b/scripts/qemugdb/timers.py
@@ -1,4 +1,3 @@
-# -*- coding: utf-8 -*-
 # GDB debugging support
 #
 # Copyright 2017 Linaro Ltd
@@ -14,6 +13,7 @@
 
 import gdb
 
+
 class TimersCommand(gdb.Command):
     '''Display the current QEMU timers'''
 
diff --git a/scripts/qmp/qemu-ga-client b/scripts/qmp/qemu-ga-client
index 56edd0234a6..337ece8a068 100755
--- a/scripts/qmp/qemu-ga-client
+++ b/scripts/qmp/qemu-ga-client
@@ -3,6 +3,7 @@
 import os
 import sys
 
+
 sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python'))
 from qemu.utils import qemu_ga_client
 
diff --git a/scripts/qmp/qmp b/scripts/qmp/qmp
index 0f12307c876..78918e47f59 100755
--- a/scripts/qmp/qmp
+++ b/scripts/qmp/qmp
@@ -2,6 +2,7 @@
 
 import sys
 
+
 print('''This unmaintained and undocumented script was removed in preference
 for qmp-shell. The assumption is that most users are using either
 qmp-shell, socat, or pasting/piping JSON into stdio. The duplication of
diff --git a/scripts/qmp/qmp-shell b/scripts/qmp/qmp-shell
index 4a20f97db70..c81ddae4e7b 100755
--- a/scripts/qmp/qmp-shell
+++ b/scripts/qmp/qmp-shell
@@ -3,6 +3,7 @@
 import os
 import sys
 
+
 sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python'))
 from qemu.qmp import qmp_shell
 
diff --git a/scripts/qmp/qmp-shell-wrap b/scripts/qmp/qmp-shell-wrap
index 9e94da114f5..eb6e6eb2b0b 100755
--- a/scripts/qmp/qmp-shell-wrap
+++ b/scripts/qmp/qmp-shell-wrap
@@ -3,6 +3,7 @@
 import os
 import sys
 
+
 sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python'))
 from qemu.qmp import qmp_shell
 
diff --git a/scripts/qmp/qom-fuse b/scripts/qmp/qom-fuse
index d453807b273..75fefe3d914 100755
--- a/scripts/qmp/qom-fuse
+++ b/scripts/qmp/qom-fuse
@@ -3,6 +3,7 @@
 import os
 import sys
 
+
 sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python'))
 from qemu.utils.qom_fuse import QOMFuse
 
diff --git a/scripts/qmp/qom-get b/scripts/qmp/qom-get
index 04ebe052e82..0e4739d5565 100755
--- a/scripts/qmp/qom-get
+++ b/scripts/qmp/qom-get
@@ -3,6 +3,7 @@
 import os
 import sys
 
+
 sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python'))
 from qemu.utils.qom import QOMGet
 
diff --git a/scripts/qmp/qom-list b/scripts/qmp/qom-list
index 853b85a8d3f..fa3a682ffc3 100755
--- a/scripts/qmp/qom-list
+++ b/scripts/qmp/qom-list
@@ -3,6 +3,7 @@
 import os
 import sys
 
+
 sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python'))
 from qemu.utils.qom import QOMList
 
diff --git a/scripts/qmp/qom-set b/scripts/qmp/qom-set
index 06820feec42..4a05f6c2b65 100755
--- a/scripts/qmp/qom-set
+++ b/scripts/qmp/qom-set
@@ -3,6 +3,7 @@
 import os
 import sys
 
+
 sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python'))
 from qemu.utils.qom import QOMSet
 
diff --git a/scripts/qmp/qom-tree b/scripts/qmp/qom-tree
index 760e172277e..3d611982b30 100755
--- a/scripts/qmp/qom-tree
+++ b/scripts/qmp/qom-tree
@@ -3,6 +3,7 @@
 import os
 import sys
 
+
 sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python'))
 from qemu.utils.qom import QOMTree
 
diff --git a/scripts/qom-cast-macro-clean-cocci-gen.py b/scripts/qom-cast-macro-clean-cocci-gen.py
index 5aa51d0c18e..02db4d622bb 100644
--- a/scripts/qom-cast-macro-clean-cocci-gen.py
+++ b/scripts/qom-cast-macro-clean-cocci-gen.py
@@ -23,6 +23,7 @@
 import re
 import sys
 
+
 assert len(sys.argv) > 0
 
 def print_cocci_rule(qom_typedef, qom_cast_macro):
@@ -44,7 +45,7 @@ def print_cocci_rule(qom_typedef, qom_cast_macro):
 
 for fn in sys.argv[1:]:
     try:
-        content = open(fn, 'rt').read()
+        content = open(fn).read()
     except:
         continue
     for pattern in patterns:
diff --git a/scripts/render_block_graph.py b/scripts/render_block_graph.py
index 3e1a2e3fa71..6db52cb2646 100755
--- a/scripts/render_block_graph.py
+++ b/scripts/render_block_graph.py
@@ -18,12 +18,14 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
+import json
 import os
-import sys
 import subprocess
-import json
+import sys
+
 from graphviz import Digraph
 
+
 sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'python'))
 from qemu.qmp import QMPError
 from qemu.qmp.legacy import QEMUMonitorProtocol
@@ -53,16 +55,16 @@ def render_block_graph(qmp, filename, format='png'):
 
     graph = Digraph(comment='Block Nodes Graph')
     graph.format = format
-    graph.node('permission symbols:\l'
-               '  w - Write\l'
-               '  r - consistent-Read\l'
-               '  u - write - Unchanged\l'
-               '  g - Graph-mod\l'
-               '  s - reSize\l'
-               'edge label scheme:\l'
-               '  <child type>\l'
-               '  <perm>\l'
-               '  <shared_perm>\l', shape='none')
+    graph.node(r'permission symbols:\l'
+               r'  w - Write\l'
+               r'  r - consistent-Read\l'
+               r'  u - write - Unchanged\l'
+               r'  g - Graph-mod\l'
+               r'  s - reSize\l'
+               r'edge label scheme:\l'
+               r'  <child type>\l'
+               r'  <perm>\l'
+               r'  <shared_perm>\l', shape='none')
 
     for n in block_graph['nodes']:
         if n['type'] == 'block-driver':
@@ -83,7 +85,7 @@ def render_block_graph(qmp, filename, format='png'):
         graph.node(str(n['id']), label, shape=shape)
 
     for e in block_graph['edges']:
-        label = '%s\l%s\l%s\l' % (e['name'], perm(e['perm']),
+        label = r'%s\l%s\l%s\l' % (e['name'], perm(e['perm']),
                                   perm(e['shared-perm']))
         graph.edge(str(e['parent']), str(e['child']), label=label)
 
diff --git a/scripts/replay-dump.py b/scripts/replay-dump.py
index 4ce7ff51cc7..02470fd554d 100755
--- a/scripts/replay-dump.py
+++ b/scripts/replay-dump.py
@@ -1,5 +1,4 @@
 #!/usr/bin/env python3
-# -*- coding: utf-8 -*-
 #
 # Dump the contents of a recorded execution stream
 #
@@ -19,18 +18,19 @@
 # License along with this library; if not, see <http://www.gnu.org/licenses/>.
 
 import argparse
-import struct
-import os
-import sys
 from collections import namedtuple
+import os
 from os import path
+import struct
+import sys
+
 
 # This mirrors some of the global replay state which some of the
 # stream loading refers to. Some decoders may read the next event so
 # we need handle that case. Calling reuse_event will ensure the next
 # event is read from the cache rather than advancing the file.
 
-class ReplayState(object):
+class ReplayState:
     def __init__(self):
         self.event = -1
         self.event_count = 0
diff --git a/scripts/rust/rustc_args.py b/scripts/rust/rustc_args.py
index 63b0748e0d3..0356c3dd7e7 100644
--- a/scripts/rust/rustc_args.py
+++ b/scripts/rust/rustc_args.py
@@ -25,10 +25,12 @@
 """
 
 import argparse
+from collections.abc import Iterable, Mapping
 from dataclasses import dataclass
 import logging
 from pathlib import Path
-from typing import Any, Iterable, List, Mapping, Optional, Set
+from typing import Any, Optional
+
 
 try:
     import tomllib
@@ -41,7 +43,7 @@
 class CargoTOML:
     tomldata: Mapping[Any, Any]
     workspace_data: Mapping[Any, Any]
-    check_cfg: Set[str]
+    check_cfg: set[str]
 
     def __init__(self, path: Optional[str], workspace: Optional[str]):
         if path is not None:
@@ -78,7 +80,7 @@ def get_table(self, key: str, can_be_workspace: bool = False) -> Mapping[Any, An
 
 @dataclass
 class LintFlag:
-    flags: List[str]
+    flags: list[str]
     priority: int
 
 
@@ -199,7 +201,7 @@ def main() -> None:
         logging.basicConfig(level=logging.DEBUG)
     logging.debug("args: %s", args)
 
-    rustc_version = tuple((int(x) for x in args.rustc_version.split('.')[0:2]))
+    rustc_version = tuple(int(x) for x in args.rustc_version.split('.')[0:2])
     if args.workspace:
         workspace_cargo_toml = Path(args.workspace, "Cargo.toml").resolve()
         cargo_toml = CargoTOML(args.cargo_toml, str(workspace_cargo_toml))
diff --git a/scripts/shaderinclude.py b/scripts/shaderinclude.py
index ab2aade2cd9..67b17782517 100644
--- a/scripts/shaderinclude.py
+++ b/scripts/shaderinclude.py
@@ -4,8 +4,8 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-import sys
 import os
+import sys
 
 
 def main(args):
@@ -14,7 +14,7 @@ def main(args):
     varname = basename.replace('-', '_').replace('.', '_')
 
     with os.fdopen(sys.stdout.fileno(), "wt", closefd=False, newline='\n') as stdout:
-        with open(file_path, "r", encoding='utf-8') as file:
+        with open(file_path, encoding='utf-8') as file:
             print(f'static GLchar {varname}_src[] =', file=stdout)
             for line in file:
                 line = line.rstrip()
diff --git a/scripts/signrom.py b/scripts/signrom.py
index 43693dba56f..a5917a20291 100755
--- a/scripts/signrom.py
+++ b/scripts/signrom.py
@@ -9,8 +9,9 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or later.
 # See the COPYING file in the top-level directory.
 
-import sys
 import struct
+import sys
+
 
 if len(sys.argv) < 3:
     print('usage: signrom.py input output')
diff --git a/scripts/simplebench/bench-backup.py b/scripts/simplebench/bench-backup.py
index 5a0675c593c..75b564be370 100755
--- a/scripts/simplebench/bench-backup.py
+++ b/scripts/simplebench/bench-backup.py
@@ -21,9 +21,14 @@
 import argparse
 import json
 
-import simplebench
+from bench_block_job import (
+    bench_block_copy,
+    drv_file,
+    drv_nbd,
+    drv_qcow2,
+)
 from results_to_text import results_to_text
-from bench_block_job import bench_block_copy, drv_file, drv_nbd, drv_qcow2
+import simplebench
 
 
 def bench_func(env, case):
diff --git a/scripts/simplebench/bench-example.py b/scripts/simplebench/bench-example.py
index fc370691e04..0b54b19220d 100644
--- a/scripts/simplebench/bench-example.py
+++ b/scripts/simplebench/bench-example.py
@@ -18,9 +18,9 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import simplebench
-from results_to_text import results_to_text
 from bench_block_job import bench_block_copy, drv_file, drv_nbd
+from results_to_text import results_to_text
+import simplebench
 
 
 def bench_func(env, case):
diff --git a/scripts/simplebench/bench_block_job.py b/scripts/simplebench/bench_block_job.py
index e575a3af10e..01aeaf51cd1 100755
--- a/scripts/simplebench/bench_block_job.py
+++ b/scripts/simplebench/bench_block_job.py
@@ -19,11 +19,12 @@
 #
 
 
-import sys
+import json
 import os
-import subprocess
 import socket
-import json
+import subprocess
+import sys
+
 
 sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python'))
 from qemu.machine import QEMUMachine
@@ -56,7 +57,7 @@ def bench_block_job(cmd, cmd_args, qemu_args):
         res = vm.qmp(cmd, **cmd_args)
         if res != {'return': {}}:
             vm.shutdown()
-            return {'error': '"{}" command failed: {}'.format(cmd, str(res))}
+            return {'error': f'"{cmd}" command failed: {str(res)}'}
 
         e = vm.event_wait('JOB_STATUS_CHANGE')
         assert e['data']['status'] == 'created'
diff --git a/scripts/simplebench/bench_prealloc.py b/scripts/simplebench/bench_prealloc.py
index 85f588c597a..782657a2db6 100755
--- a/scripts/simplebench/bench_prealloc.py
+++ b/scripts/simplebench/bench_prealloc.py
@@ -19,19 +19,19 @@
 #
 
 
-import sys
+import json
 import os
-import subprocess
 import re
-import json
+import subprocess
+import sys
 
-import simplebench
 from results_to_text import results_to_text
+import simplebench
 
 
 def qemu_img_bench(args):
     p = subprocess.run(args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
-                       universal_newlines=True)
+                       text=True)
 
     if p.returncode == 0:
         try:
diff --git a/scripts/simplebench/bench_write_req.py b/scripts/simplebench/bench_write_req.py
index da601ea2fe5..80b81ee045e 100755
--- a/scripts/simplebench/bench_write_req.py
+++ b/scripts/simplebench/bench_write_req.py
@@ -22,11 +22,12 @@
 #
 
 
-import sys
 import os
 import subprocess
-import simplebench
+import sys
+
 from results_to_text import results_to_text
+import simplebench
 
 
 def bench_func(env, case):
diff --git a/scripts/simplebench/img_bench_templater.py b/scripts/simplebench/img_bench_templater.py
index f8e1540ada4..bf0c55a8c5f 100755
--- a/scripts/simplebench/img_bench_templater.py
+++ b/scripts/simplebench/img_bench_templater.py
@@ -19,13 +19,13 @@
 #
 
 
-import sys
-import subprocess
-import re
 import json
+import re
+import subprocess
+import sys
 
-import simplebench
 from results_to_text import results_to_text
+import simplebench
 from table_templater import Templater
 
 
@@ -33,7 +33,7 @@ def bench_func(env, case):
     test = templater.gen(env['data'], case['data'])
 
     p = subprocess.run(test, shell=True, stdout=subprocess.PIPE,
-                       stderr=subprocess.STDOUT, universal_newlines=True)
+                       stderr=subprocess.STDOUT, text=True)
 
     if p.returncode == 0:
         try:
diff --git a/scripts/simplebench/results_to_text.py b/scripts/simplebench/results_to_text.py
index d561e5e2dbe..7e908b34649 100755
--- a/scripts/simplebench/results_to_text.py
+++ b/scripts/simplebench/results_to_text.py
@@ -19,8 +19,10 @@
 #
 
 import math
+
 import tabulate
 
+
 # We want leading whitespace for difference row cells (see below)
 tabulate.PRESERVE_WHITESPACE = True
 
@@ -115,8 +117,8 @@ def results_to_text(results):
 
 
 if __name__ == '__main__':
-    import sys
     import json
+    import sys
 
     if len(sys.argv) < 2:
         print(f'USAGE: {sys.argv[0]} results.json')
diff --git a/scripts/simplebench/simplebench.py b/scripts/simplebench/simplebench.py
index 8efca2af988..c9ee1d4cf89 100644
--- a/scripts/simplebench/simplebench.py
+++ b/scripts/simplebench/simplebench.py
@@ -67,7 +67,7 @@ def bench_one(test_func, test_env, test_case, count=5, initial_run=True,
     for i in range(count):
         t = time.time()
 
-        print('  #run {}'.format(i+1))
+        print(f'  #run {i+1}')
         do_drop_caches()
         res = test_func(test_env, test_case)
         print('   ', res)
diff --git a/scripts/simplebench/table_templater.py b/scripts/simplebench/table_templater.py
index 950f3b30247..3d606a6b0f4 100644
--- a/scripts/simplebench/table_templater.py
+++ b/scripts/simplebench/table_templater.py
@@ -17,9 +17,11 @@
 #
 
 import itertools
+
 from lark import Lark
 
-grammar = """
+
+grammar = r"""
 start: ( text | column_switch | row_switch )+
 
 column_switch: "{" text ["|" text]+ "}"
diff --git a/scripts/simpletrace.py b/scripts/simpletrace.py
index cef81b0707f..a013e4402de 100755
--- a/scripts/simpletrace.py
+++ b/scripts/simpletrace.py
@@ -9,13 +9,15 @@
 #
 # For help see docs/devel/tracing.rst
 
-import sys
-import struct
 import inspect
+import struct
+import sys
 import warnings
-from tracetool import read_events, Event
+
+from tracetool import Event, read_events
 from tracetool.backend.simple import is_string
 
+
 __all__ = ['Analyzer', 'Analyzer2', 'process', 'run']
 
 # This is the binary format that the QEMU "simple" trace backend
@@ -166,11 +168,9 @@ def runstate_set(self, timestamp, pid, new_state):
 
     def begin(self):
         """Called at the start of the trace."""
-        pass
 
     def catchall(self, event, rec):
         """Called if no specific method for processing a trace event has been found."""
-        pass
 
     def _build_fn(self, event):
         fn = getattr(self, event.name, None)
@@ -208,7 +208,6 @@ def _process_event(self, rec_args, *, event, event_id, timestamp_ns, pid, **kwar
 
     def end(self):
         """Called at the end of the trace."""
-        pass
 
     def __enter__(self):
         self.begin()
@@ -263,7 +262,6 @@ def runstate_set(self, new_state, *, timestamp_ns, pid, **kwargs):
 
     def catchall(self, *rec_args, event, timestamp_ns, pid, event_id, **kwargs):
         """Called if no specific method for processing a trace event has been found."""
-        pass
 
     def _process_event(self, rec_args, *, event, **kwargs):
         fn = getattr(self, event.name, self.catchall)
@@ -279,7 +277,7 @@ def process(events, log, analyzer, read_header=True):
     """
 
     if isinstance(events, str):
-        with open(events, 'r') as f:
+        with open(events) as f:
             events_list = read_events(f, events)
     elif isinstance(events, list):
         # Treat as a list of events already produced by tracetool.read_events
@@ -332,7 +330,7 @@ def run(analyzer):
     except (AssertionError, ValueError):
         raise SimpleException(f'usage: {sys.argv[0]} [--no-header] <trace-events> <trace-file>\n')
 
-    with open(trace_event_path, 'r') as events_fobj, open(trace_file_path, 'rb') as log_fobj:
+    with open(trace_event_path) as events_fobj, open(trace_file_path, 'rb') as log_fobj:
         process(events_fobj, log_fobj, analyzer, read_header=not no_header)
 
 if __name__ == '__main__':
diff --git a/scripts/symlink-install-tree.py b/scripts/symlink-install-tree.py
index b72563895c5..cc197e5721c 100644
--- a/scripts/symlink-install-tree.py
+++ b/scripts/symlink-install-tree.py
@@ -1,13 +1,14 @@
 #!/usr/bin/env python3
 
-from pathlib import PurePath
 import errno
 import json
 import os
+from pathlib import PurePath
 import shlex
 import subprocess
 import sys
 
+
 def destdir_join(d1: str, d2: str) -> str:
     if not d1:
         return d2
diff --git a/scripts/tracetool.py b/scripts/tracetool.py
index 5de9ce96d30..2a9555a7824 100755
--- a/scripts/tracetool.py
+++ b/scripts/tracetool.py
@@ -1,5 +1,4 @@
 #!/usr/bin/env python3
-# -*- coding: utf-8 -*-
 
 """
 Command-line wrapper for the tracetool machinery.
@@ -13,8 +12,8 @@
 __email__      = "stefanha@redhat.com"
 
 
-import sys
 import getopt
+import sys
 
 from tracetool import error_write, out, out_open
 import tracetool.backend
@@ -125,7 +124,7 @@ def main(args):
         error_opt("missing trace-events and output filepaths")
     events = []
     for arg in args[:-1]:
-        with open(arg, "r") as fh:
+        with open(arg) as fh:
             events.extend(tracetool.read_events(fh, arg))
 
     out_open(args[-1])
diff --git a/scripts/tracetool/__init__.py b/scripts/tracetool/__init__.py
index bc03238c0fa..b9de8112a0e 100644
--- a/scripts/tracetool/__init__.py
+++ b/scripts/tracetool/__init__.py
@@ -1,5 +1,3 @@
-# -*- coding: utf-8 -*-
-
 """
 Machinery for generating tracing-related intermediate files.
 """
@@ -16,8 +14,8 @@
 import sys
 import weakref
 
-import tracetool.format
 import tracetool.backend
+import tracetool.format
 
 
 def error_write(*lines):
@@ -37,7 +35,7 @@ def error(*lines):
 def out_open(filename):
     global out_filename, out_fobj
     out_filename = filename
-    out_fobj = open(filename, 'wt')
+    out_fobj = open(filename, 'w')
 
 def out(*lines, **kwargs):
     """Write a set of output lines.
@@ -190,7 +188,7 @@ def casted(self):
         return ["(%s)%s" % (type_, name) for type_, name in self._args]
 
 
-class Event(object):
+class Event:
     """Event description.
 
     Attributes
@@ -217,7 +215,7 @@ class Event(object):
                       r"(?:(?:(?P<fmt_trans>\".+),)?\s*(?P<fmt>\".+))?"
                       r"\s*")
 
-    _VALID_PROPS = set(["disable", "vcpu"])
+    _VALID_PROPS = {"disable", "vcpu"}
 
     def __init__(self, name, props, fmt, args, lineno, filename, orig=None,
                  event_trans=None, event_exec=None):
@@ -378,7 +376,6 @@ def read_events(fobj, fname):
 
 class TracetoolError (Exception):
     """Exception for calls to generate."""
-    pass
 
 
 def try_import(mod_name, attr_name=None, attr_default=None):
diff --git a/scripts/tracetool/backend/__init__.py b/scripts/tracetool/backend/__init__.py
index 7bfcc86cc53..c0f50bbccfb 100644
--- a/scripts/tracetool/backend/__init__.py
+++ b/scripts/tracetool/backend/__init__.py
@@ -1,5 +1,3 @@
-# -*- coding: utf-8 -*-
-
 """
 Backend management.
 
diff --git a/scripts/tracetool/backend/dtrace.py b/scripts/tracetool/backend/dtrace.py
index e17edc9b9d8..4835454193d 100644
--- a/scripts/tracetool/backend/dtrace.py
+++ b/scripts/tracetool/backend/dtrace.py
@@ -1,5 +1,3 @@
-# -*- coding: utf-8 -*-
-
 """
 DTrace/SystemTAP backend.
 """
diff --git a/scripts/tracetool/backend/ftrace.py b/scripts/tracetool/backend/ftrace.py
index baed2ae61cb..df53b053168 100644
--- a/scripts/tracetool/backend/ftrace.py
+++ b/scripts/tracetool/backend/ftrace.py
@@ -1,5 +1,3 @@
-# -*- coding: utf-8 -*-
-
 """
 Ftrace built-in backend.
 """
diff --git a/scripts/tracetool/backend/log.py b/scripts/tracetool/backend/log.py
index de27b7e62e4..385a155d91c 100644
--- a/scripts/tracetool/backend/log.py
+++ b/scripts/tracetool/backend/log.py
@@ -1,5 +1,3 @@
-# -*- coding: utf-8 -*-
-
 """
 Stderr built-in backend.
 """
diff --git a/scripts/tracetool/backend/simple.py b/scripts/tracetool/backend/simple.py
index 2688d4b64b3..9cda7be2058 100644
--- a/scripts/tracetool/backend/simple.py
+++ b/scripts/tracetool/backend/simple.py
@@ -1,5 +1,3 @@
-# -*- coding: utf-8 -*-
-
 """
 Simple built-in backend.
 """
diff --git a/scripts/tracetool/backend/syslog.py b/scripts/tracetool/backend/syslog.py
index 012970f6cc0..024653444a9 100644
--- a/scripts/tracetool/backend/syslog.py
+++ b/scripts/tracetool/backend/syslog.py
@@ -1,5 +1,3 @@
-# -*- coding: utf-8 -*-
-
 """
 Syslog built-in backend.
 """
diff --git a/scripts/tracetool/backend/ust.py b/scripts/tracetool/backend/ust.py
index c857516f212..6cc651646dd 100644
--- a/scripts/tracetool/backend/ust.py
+++ b/scripts/tracetool/backend/ust.py
@@ -1,5 +1,3 @@
-# -*- coding: utf-8 -*-
-
 """
 LTTng User Space Tracing backend.
 """
diff --git a/scripts/tracetool/format/__init__.py b/scripts/tracetool/format/__init__.py
index 2dc46f3dd93..aa81f13f656 100644
--- a/scripts/tracetool/format/__init__.py
+++ b/scripts/tracetool/format/__init__.py
@@ -1,5 +1,3 @@
-# -*- coding: utf-8 -*-
-
 """
 Format management.
 
diff --git a/scripts/tracetool/format/c.py b/scripts/tracetool/format/c.py
index 69edf0d588e..02eeb3b236f 100644
--- a/scripts/tracetool/format/c.py
+++ b/scripts/tracetool/format/c.py
@@ -1,5 +1,3 @@
-# -*- coding: utf-8 -*-
-
 """
 trace/generated-tracers.c
 """
diff --git a/scripts/tracetool/format/d.py b/scripts/tracetool/format/d.py
index ebfb7142002..a5e165902dd 100644
--- a/scripts/tracetool/format/d.py
+++ b/scripts/tracetool/format/d.py
@@ -1,5 +1,3 @@
-# -*- coding: utf-8 -*-
-
 """
 trace/generated-tracers.dtrace (DTrace only).
 """
@@ -12,9 +10,10 @@
 __email__      = "stefanha@redhat.com"
 
 
-from tracetool import out
 from sys import platform
 
+from tracetool import out
+
 
 # Reserved keywords from
 # https://wikis.oracle.com/display/DTrace/Types,+Operators+and+Expressions
diff --git a/scripts/tracetool/format/h.py b/scripts/tracetool/format/h.py
index ea126b07ea5..003ce4b8a40 100644
--- a/scripts/tracetool/format/h.py
+++ b/scripts/tracetool/format/h.py
@@ -1,5 +1,3 @@
-# -*- coding: utf-8 -*-
-
 """
 trace/generated-tracers.h
 """
diff --git a/scripts/tracetool/format/log_stap.py b/scripts/tracetool/format/log_stap.py
index b49afababd6..0ecb0f28c76 100644
--- a/scripts/tracetool/format/log_stap.py
+++ b/scripts/tracetool/format/log_stap.py
@@ -1,5 +1,3 @@
-# -*- coding: utf-8 -*-
-
 """
 Generate .stp file that printfs log messages (DTrace with SystemTAP only).
 """
@@ -18,6 +16,7 @@
 from tracetool.backend.simple import is_string
 from tracetool.format.stap import stap_escape
 
+
 def global_var_name(name):
     return probeprefix().replace(".", "_") + "_" + name
 
diff --git a/scripts/tracetool/format/simpletrace_stap.py b/scripts/tracetool/format/simpletrace_stap.py
index 4f4633b4e68..5b2ea8ea4b1 100644
--- a/scripts/tracetool/format/simpletrace_stap.py
+++ b/scripts/tracetool/format/simpletrace_stap.py
@@ -1,5 +1,3 @@
-# -*- coding: utf-8 -*-
-
 """
 Generate .stp file that outputs simpletrace binary traces (DTrace with SystemTAP only).
 """
@@ -17,6 +15,7 @@
 from tracetool.backend.simple import is_string
 from tracetool.format.stap import stap_escape
 
+
 def global_var_name(name):
     return probeprefix().replace(".", "_") + "_" + name
 
diff --git a/scripts/tracetool/format/stap.py b/scripts/tracetool/format/stap.py
index a218b0445c9..e0df177e938 100644
--- a/scripts/tracetool/format/stap.py
+++ b/scripts/tracetool/format/stap.py
@@ -1,5 +1,3 @@
-# -*- coding: utf-8 -*-
-
 """
 Generate .stp file (DTrace with SystemTAP only).
 """
diff --git a/scripts/tracetool/format/ust_events_c.py b/scripts/tracetool/format/ust_events_c.py
index deced9533dd..5dd4a34604d 100644
--- a/scripts/tracetool/format/ust_events_c.py
+++ b/scripts/tracetool/format/ust_events_c.py
@@ -1,5 +1,3 @@
-# -*- coding: utf-8 -*-
-
 """
 trace/generated-ust.c
 """
diff --git a/scripts/tracetool/format/ust_events_h.py b/scripts/tracetool/format/ust_events_h.py
index b99fe6896ba..4ae2126633d 100644
--- a/scripts/tracetool/format/ust_events_h.py
+++ b/scripts/tracetool/format/ust_events_h.py
@@ -1,5 +1,3 @@
-# -*- coding: utf-8 -*-
-
 """
 trace/generated-ust-provider.h
 """
diff --git a/scripts/u2f-setup-gen.py b/scripts/u2f-setup-gen.py
index 2122598fed8..b000edfbaaf 100755
--- a/scripts/u2f-setup-gen.py
+++ b/scripts/u2f-setup-gen.py
@@ -9,16 +9,19 @@
 # or, at your option, any later version.  See the COPYING file in
 # the top-level directory.
 
-import sys
 import os
 from random import randint
-from typing import Tuple
+import sys
 
+from OpenSSL import crypto
 from cryptography.hazmat.backends import default_backend
 from cryptography.hazmat.primitives.asymmetric import ec
-from cryptography.hazmat.primitives.serialization import Encoding, \
-    NoEncryption, PrivateFormat, PublicFormat
-from OpenSSL import crypto
+from cryptography.hazmat.primitives.serialization import (
+    Encoding,
+    NoEncryption,
+    PrivateFormat,
+    PublicFormat,
+)
 
 
 def write_setup_dir(dirpath: str, privkey_pem: bytes, cert_pem: bytes,
@@ -53,7 +56,7 @@ def write_setup_dir(dirpath: str, privkey_pem: bytes, cert_pem: bytes,
         f.write(f'{str(counter)}\n')
 
 
-def generate_ec_key_pair() -> Tuple[str, str]:
+def generate_ec_key_pair() -> tuple[str, str]:
     """
     Generate an ec key pair.
 
diff --git a/scripts/undefsym.py b/scripts/undefsym.py
index 4b6a72d95f4..7e83ae991fc 100644
--- a/scripts/undefsym.py
+++ b/scripts/undefsym.py
@@ -8,8 +8,9 @@
 # Then the DSO loading would fail because of the missing symbol.
 
 
-import sys
 import subprocess
+import sys
+
 
 def filter_lines_set(stdout, from_staticlib):
     linesSet = set()
diff --git a/scripts/userfaultfd-wrlat.py b/scripts/userfaultfd-wrlat.py
index 5f36c7af565..4c37715e7a8 100755
--- a/scripts/userfaultfd-wrlat.py
+++ b/scripts/userfaultfd-wrlat.py
@@ -17,11 +17,11 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later.  See the COPYING file in the top-level directory.
 
-from __future__ import print_function
-from bcc import BPF
-from ctypes import c_ushort, c_int, c_ulonglong
-from time import sleep
 from sys import argv
+from time import sleep
+
+from bcc import BPF
+
 
 def usage():
     print("USAGE: %s [interval [count]]" % argv[0])
diff --git a/scripts/vmstate-static-checker.py b/scripts/vmstate-static-checker.py
index 2335e25f94c..bd6c463e3b6 100755
--- a/scripts/vmstate-static-checker.py
+++ b/scripts/vmstate-static-checker.py
@@ -23,6 +23,7 @@
 import json
 import sys
 
+
 # Count the number of errors found
 taint = 0
 
diff --git a/scripts/xml-preprocess-test.py b/scripts/xml-preprocess-test.py
index dd92579969a..222c8a79a77 100644
--- a/scripts/xml-preprocess-test.py
+++ b/scripts/xml-preprocess-test.py
@@ -7,12 +7,13 @@
 
 import contextlib
 import importlib
+from io import StringIO
 import os
 import platform
 import subprocess
 import tempfile
 import unittest
-from io import StringIO
+
 
 xmlpp = importlib.import_module("xml-preprocess")
 
diff --git a/scripts/xml-preprocess.py b/scripts/xml-preprocess.py
index 57f1d289125..a79042240e7 100644
--- a/scripts/xml-preprocess.py
+++ b/scripts/xml-preprocess.py
@@ -87,7 +87,7 @@ def _pp_include(self, xml_str: str) -> str:
         matches = re.findall(include_regex, xml_str)
         for group_inc, group_xml in matches:
             inc_file_path = group_xml.strip()
-            with open(inc_file_path, "r", encoding="utf-8") as inc_file:
+            with open(inc_file_path, encoding="utf-8") as inc_file:
                 inc_file_content = inc_file.read()
                 xml_str = xml_str.replace(group_inc, inc_file_content)
         return xml_str
@@ -262,7 +262,7 @@ def preprocess(self, xml_str: str) -> str:
 
 
 def preprocess_xml(path: str) -> str:
-    with open(path, "r", encoding="utf-8") as original_file:
+    with open(path, encoding="utf-8") as original_file:
         input_xml = original_file.read()
 
         proc = Preprocessor()
diff --git a/target/hexagon/gen_analyze_funcs.py b/target/hexagon/gen_analyze_funcs.py
index 3ac7cc2cfe5..7de6fe6afe6 100755
--- a/target/hexagon/gen_analyze_funcs.py
+++ b/target/hexagon/gen_analyze_funcs.py
@@ -17,9 +17,6 @@
 ##  along with this program; if not, see <http://www.gnu.org/licenses/>.
 ##
 
-import sys
-import re
-import string
 import hex_common
 
 
diff --git a/target/hexagon/gen_decodetree.py b/target/hexagon/gen_decodetree.py
index ce703af41d4..d25667b5cd6 100755
--- a/target/hexagon/gen_decodetree.py
+++ b/target/hexagon/gen_decodetree.py
@@ -17,14 +17,13 @@
 ##  along with this program; if not, see <http://www.gnu.org/licenses/>.
 ##
 
-import io
+import argparse
 import re
-
 import sys
-import textwrap
-import iset
+
 import hex_common
-import argparse
+import iset
+
 
 encs = {
     tag: "".join(reversed(iset.iset[tag]["enc"].replace(" ", "")))
diff --git a/target/hexagon/gen_helper_funcs.py b/target/hexagon/gen_helper_funcs.py
index c1f806ac4b2..fcc5032881a 100755
--- a/target/hexagon/gen_helper_funcs.py
+++ b/target/hexagon/gen_helper_funcs.py
@@ -17,9 +17,6 @@
 ##  along with this program; if not, see <http://www.gnu.org/licenses/>.
 ##
 
-import sys
-import re
-import string
 import hex_common
 
 
diff --git a/target/hexagon/gen_helper_protos.py b/target/hexagon/gen_helper_protos.py
index 77f8e0a6a32..f012021352f 100755
--- a/target/hexagon/gen_helper_protos.py
+++ b/target/hexagon/gen_helper_protos.py
@@ -17,11 +17,9 @@
 ##  along with this program; if not, see <http://www.gnu.org/licenses/>.
 ##
 
-import sys
-import re
-import string
 import hex_common
 
+
 ##
 ## Generate the DEF_HELPER prototype for an instruction
 ##     For A2_add: Rd32=add(Rs32,Rt32)
diff --git a/target/hexagon/gen_idef_parser_funcs.py b/target/hexagon/gen_idef_parser_funcs.py
index 2f6e826f76d..aa046264e73 100644
--- a/target/hexagon/gen_idef_parser_funcs.py
+++ b/target/hexagon/gen_idef_parser_funcs.py
@@ -17,11 +17,7 @@
 ##  along with this program; if not, see <http://www.gnu.org/licenses/>.
 ##
 
-import sys
-import re
-import string
 import argparse
-from io import StringIO
 
 import hex_common
 
diff --git a/target/hexagon/gen_op_attribs.py b/target/hexagon/gen_op_attribs.py
index bbbb02df3a2..be8f5a76fa6 100755
--- a/target/hexagon/gen_op_attribs.py
+++ b/target/hexagon/gen_op_attribs.py
@@ -17,12 +17,10 @@
 ##  along with this program; if not, see <http://www.gnu.org/licenses/>.
 ##
 
-import sys
-import re
-import string
-import hex_common
 import argparse
 
+import hex_common
+
 
 def main():
     parser = argparse.ArgumentParser(
diff --git a/target/hexagon/gen_opcodes_def.py b/target/hexagon/gen_opcodes_def.py
index 94a19ff412e..a2f3e0e3da3 100755
--- a/target/hexagon/gen_opcodes_def.py
+++ b/target/hexagon/gen_opcodes_def.py
@@ -17,12 +17,10 @@
 ##  along with this program; if not, see <http://www.gnu.org/licenses/>.
 ##
 
-import sys
-import re
-import string
-import hex_common
 import argparse
 
+import hex_common
+
 
 def main():
     parser = argparse.ArgumentParser(
diff --git a/target/hexagon/gen_printinsn.py b/target/hexagon/gen_printinsn.py
index d5f969960ad..00b6f37de49 100755
--- a/target/hexagon/gen_printinsn.py
+++ b/target/hexagon/gen_printinsn.py
@@ -17,11 +17,10 @@
 ##  along with this program; if not, see <http://www.gnu.org/licenses/>.
 ##
 
-import sys
+import argparse
 import re
-import string
+
 import hex_common
-import argparse
 
 
 ##
diff --git a/target/hexagon/gen_tcg_func_table.py b/target/hexagon/gen_tcg_func_table.py
index 299a39b1aa0..52bdce7c4f5 100755
--- a/target/hexagon/gen_tcg_func_table.py
+++ b/target/hexagon/gen_tcg_func_table.py
@@ -17,12 +17,10 @@
 ##  along with this program; if not, see <http://www.gnu.org/licenses/>.
 ##
 
-import sys
-import re
-import string
-import hex_common
 import argparse
 
+import hex_common
+
 
 def main():
     parser = argparse.ArgumentParser(
diff --git a/target/hexagon/gen_tcg_funcs.py b/target/hexagon/gen_tcg_funcs.py
index c2ba91ddc04..b458dcd5b64 100755
--- a/target/hexagon/gen_tcg_funcs.py
+++ b/target/hexagon/gen_tcg_funcs.py
@@ -17,9 +17,6 @@
 ##  along with this program; if not, see <http://www.gnu.org/licenses/>.
 ##
 
-import sys
-import re
-import string
 import hex_common
 
 
diff --git a/target/hexagon/gen_trans_funcs.py b/target/hexagon/gen_trans_funcs.py
index 45da1b7b5df..62209733923 100755
--- a/target/hexagon/gen_trans_funcs.py
+++ b/target/hexagon/gen_trans_funcs.py
@@ -17,14 +17,14 @@
 ##  along with this program; if not, see <http://www.gnu.org/licenses/>.
 ##
 
-import io
+import argparse
 import re
-
 import sys
 import textwrap
-import iset
+
 import hex_common
-import argparse
+import iset
+
 
 encs = {
     tag: "".join(reversed(iset.iset[tag]["enc"].replace(" ", "")))
diff --git a/target/hexagon/hex_common.py b/target/hexagon/hex_common.py
index 758e5fd12df..dd2d7be7cb9 100755
--- a/target/hexagon/hex_common.py
+++ b/target/hexagon/hex_common.py
@@ -17,11 +17,10 @@
 ##  along with this program; if not, see <http://www.gnu.org/licenses/>.
 ##
 
-import sys
+import argparse
 import re
-import string
 import textwrap
-import argparse
+
 
 behdict = {}  # tag ->behavior
 semdict = {}  # tag -> semantics
@@ -105,7 +104,7 @@ def calculate_attribs():
 
     # Recurse down macros, find attributes from sub-macros
     macroValues = list(macros.values())
-    allmacros_restr = "|".join(set([m.re.pattern for m in macroValues]))
+    allmacros_restr = "|".join({m.re.pattern for m in macroValues})
     allmacros_re = re.compile(allmacros_restr)
     for macro in macroValues:
         expand_macro_attribs(macro, allmacros_re)
@@ -140,7 +139,7 @@ def ATTRIBUTES(tag, attribstring):
         attribdict[tag].add(attrib.strip())
 
 
-class Macro(object):
+class Macro:
     __slots__ = ["key", "name", "beh", "attribs", "re"]
 
     def __init__(self, name, beh, attribs):
@@ -278,7 +277,7 @@ def imm_name(immlett):
 
 def read_semantics_file(name):
     eval_line = ""
-    for line in open(name, "rt").readlines():
+    for line in open(name).readlines():
         if not line.startswith("#"):
             eval_line += line
             if line.endswith("\\\n"):
@@ -290,7 +289,7 @@ def read_semantics_file(name):
 
 def read_overrides_file(name):
     overridere = re.compile(r"#define fGEN_TCG_([A-Za-z0-9_]+)\(.*")
-    for line in open(name, "rt").readlines():
+    for line in open(name).readlines():
         if not overridere.match(line):
             continue
         tag = overridere.findall(line)[0]
@@ -299,7 +298,7 @@ def read_overrides_file(name):
 
 def read_idef_parser_enabled_file(name):
     global idef_parser_enabled
-    with open(name, "r") as idef_parser_enabled_file:
+    with open(name) as idef_parser_enabled_file:
         lines = idef_parser_enabled_file.read().strip().split("\n")
         idef_parser_enabled = set(lines)
 
diff --git a/tests/docker/docker.py b/tests/docker/docker.py
index 3b8a26704df..25346602b1e 100755
--- a/tests/docker/docker.py
+++ b/tests/docker/docker.py
@@ -11,23 +11,22 @@
 # or (at your option) any later version. See the COPYING file in
 # the top-level directory.
 
-import os
-import sys
-import subprocess
-import json
-import hashlib
-import atexit
-import uuid
 import argparse
+import atexit
 import enum
-import tempfile
+import getpass
+import hashlib
+from io import BytesIO, StringIO
+import json
+import os
 import re
+from shutil import copy, rmtree
 import signal
-import getpass
+import subprocess
+import sys
 from tarfile import TarFile, TarInfo
-from io import StringIO, BytesIO
-from shutil import copy, rmtree
-from datetime import datetime, timedelta
+import tempfile
+import uuid
 
 
 FILTERED_ENV_NAMES = ['ftp_proxy', 'http_proxy', 'https_proxy']
@@ -65,7 +64,7 @@ def _text_checksum(text):
     return _bytes_checksum(text.encode('utf-8'))
 
 def _read_dockerfile(path):
-    return open(path, 'rt', encoding='utf-8').read()
+    return open(path, encoding='utf-8').read()
 
 def _file_checksum(filename):
     return _bytes_checksum(open(filename, 'rb').read())
@@ -108,7 +107,6 @@ def _copy_with_mkdir(src, root_dir, sub_path='.', name=None):
         copy(src, dest_file)
     except FileNotFoundError:
         print("Couldn't copy %s to %s" % (src, dest_file))
-        pass
 
 
 def _get_so_libs(executable):
@@ -218,7 +216,7 @@ def _dockerfile_verify_flat(df):
     return True
 
 
-class Docker(object):
+class Docker:
     """ Running Docker commands """
     def __init__(self):
         self._command = _guess_engine_command()
@@ -378,7 +376,7 @@ def command(self, cmd, argv, quiet):
         return self._do([cmd] + argv, quiet=quiet)
 
 
-class SubCommand(object):
+class SubCommand:
     """A SubCommand template base class"""
     name = None  # Subcommand name
 
@@ -388,14 +386,12 @@ def shared_args(self, parser):
 
     def args(self, parser):
         """Setup argument parser"""
-        pass
 
     def run(self, args, argv):
         """Run command.
         args: parsed argument by argument parser.
         argv: remaining arguments from sys.argv.
         """
-        pass
 
 
 class RunCommand(SubCommand):
@@ -538,7 +534,7 @@ def run(self, args, argv):
 
         # Create a Docker buildfile
         df = StringIO()
-        df.write(u"FROM %s\n" % args.tag)
+        df.write("FROM %s\n" % args.tag)
 
         if args.executable:
             # Add the executable to the tarball, using the current
@@ -564,9 +560,8 @@ def run(self, args, argv):
                         tmp_tar.add(real_l, arcname="%s/%s" % (so_path, name))
                     except FileNotFoundError:
                         print("Couldn't add %s/%s to archive" % (so_path, name))
-                        pass
 
-            df.write(u"ADD . /\n")
+            df.write("ADD . /\n")
 
         if args.user:
             uid = os.getuid()
diff --git a/tests/functional/aspeed.py b/tests/functional/aspeed.py
index 7a40d5dda73..8661b850602 100644
--- a/tests/functional/aspeed.py
+++ b/tests/functional/aspeed.py
@@ -2,8 +2,8 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import exec_command_and_wait_for_pattern
-from qemu_test import LinuxKernelTest
+from qemu_test import LinuxKernelTest, exec_command_and_wait_for_pattern
+
 
 class AspeedTest(LinuxKernelTest):
 
diff --git a/tests/functional/qemu_test/__init__.py b/tests/functional/qemu_test/__init__.py
index 6e666a059fc..b61c83f8e8f 100644
--- a/tests/functional/qemu_test/__init__.py
+++ b/tests/functional/qemu_test/__init__.py
@@ -6,15 +6,29 @@
 # later.  See the COPYING file in the top-level directory.
 
 
+from .archive import archive_extract
 from .asset import Asset
+from .cmd import (
+    exec_command,
+    exec_command_and_wait_for_pattern,
+    get_qemu_img,
+    interrupt_interactive_console_until_pattern,
+    is_readable_executable_file,
+    wait_for_console_pattern,
+    which,
+)
 from .config import BUILD_DIR, dso_suffix
-from .cmd import is_readable_executable_file, \
-    interrupt_interactive_console_until_pattern, wait_for_console_pattern, \
-    exec_command, exec_command_and_wait_for_pattern, get_qemu_img, which
-from .testcase import QemuBaseTest, QemuUserTest, QemuSystemTest
+from .decorators import (
+    skipBigDataTest,
+    skipFlakyTest,
+    skipIfMissingCommands,
+    skipIfMissingImports,
+    skipIfNotMachine,
+    skipIfOperatingSystem,
+    skipLockedMemoryTest,
+    skipSlowTest,
+    skipUntrustedTest,
+)
 from .linuxkernel import LinuxKernelTest
-from .decorators import skipIfMissingCommands, skipIfNotMachine, \
-    skipFlakyTest, skipUntrustedTest, skipBigDataTest, skipSlowTest, \
-    skipIfMissingImports, skipIfOperatingSystem, skipLockedMemoryTest
-from .archive import archive_extract
+from .testcase import QemuBaseTest, QemuSystemTest, QemuUserTest
 from .uncompress import uncompress
diff --git a/tests/functional/qemu_test/archive.py b/tests/functional/qemu_test/archive.py
index c803fdaf6dc..f45b476868a 100644
--- a/tests/functional/qemu_test/archive.py
+++ b/tests/functional/qemu_test/archive.py
@@ -8,7 +8,7 @@
 #  Thomas Huth <thuth@redhat.com>
 
 import os
-from subprocess import check_call, run, DEVNULL
+from subprocess import DEVNULL, check_call, run
 import tarfile
 from urllib.parse import urlparse
 import zipfile
diff --git a/tests/functional/qemu_test/asset.py b/tests/functional/qemu_test/asset.py
index 704b84d0ea6..9d541126199 100644
--- a/tests/functional/qemu_test/asset.py
+++ b/tests/functional/qemu_test/asset.py
@@ -8,14 +8,15 @@
 import hashlib
 import logging
 import os
+from pathlib import Path
+from shutil import copyfileobj
 import stat
 import sys
-import unittest
-import urllib.request
 from time import sleep
-from pathlib import Path
-from shutil import copyfileobj
+import unittest
 from urllib.error import HTTPError
+import urllib.request
+
 
 class AssetError(Exception):
     def __init__(self, asset, msg, transient=False):
@@ -182,7 +183,6 @@ def fetch(self):
                         self.hash.encode('utf8'))
         except Exception as e:
             self.log.debug("Unable to set xattr on %s: %s", tmp_cache_file, e)
-            pass
 
         if not self._check(tmp_cache_file):
             tmp_cache_file.unlink()
diff --git a/tests/functional/qemu_test/decorators.py b/tests/functional/qemu_test/decorators.py
index c0d1567b142..59c31c711ab 100644
--- a/tests/functional/qemu_test/decorators.py
+++ b/tests/functional/qemu_test/decorators.py
@@ -10,6 +10,7 @@
 
 from .cmd import which
 
+
 '''
 Decorator to skip execution of a test if the list
 of command binaries is not available in $PATH.
diff --git a/tests/functional/qemu_test/linuxkernel.py b/tests/functional/qemu_test/linuxkernel.py
index 2aca0ee3cd0..4b2a4d3dbc7 100644
--- a/tests/functional/qemu_test/linuxkernel.py
+++ b/tests/functional/qemu_test/linuxkernel.py
@@ -6,7 +6,10 @@
 import hashlib
 import urllib.request
 
-from .cmd import wait_for_console_pattern, exec_command_and_wait_for_pattern
+from .cmd import (
+    exec_command_and_wait_for_pattern,
+    wait_for_console_pattern,
+)
 from .testcase import QemuSystemTest
 from .utils import get_usernet_hostfwd_port
 
diff --git a/tests/functional/qemu_test/ports.py b/tests/functional/qemu_test/ports.py
index 631b77abf6b..3b9f5f286a1 100644
--- a/tests/functional/qemu_test/ports.py
+++ b/tests/functional/qemu_test/ports.py
@@ -12,7 +12,6 @@
 import socket
 
 from .config import BUILD_DIR
-from typing import List
 
 
 class Ports():
@@ -41,7 +40,7 @@ def check_bind(self, port: int) -> bool:
 
         return True
 
-    def find_free_ports(self, count: int) -> List[int]:
+    def find_free_ports(self, count: int) -> list[int]:
         result = []
         for port in range(self.PORTS_START, self.PORTS_END):
             if self.check_bind(port):
diff --git a/tests/functional/qemu_test/testcase.py b/tests/functional/qemu_test/testcase.py
index 50c401b8c3c..63493ea4195 100644
--- a/tests/functional/qemu_test/testcase.py
+++ b/tests/functional/qemu_test/testcase.py
@@ -14,7 +14,6 @@
 import logging
 import os
 from pathlib import Path
-import pycotap
 import shutil
 from subprocess import run
 import sys
@@ -22,6 +21,7 @@
 import unittest
 import uuid
 
+import pycotap
 from qemu.machine import QEMUMachine
 from qemu.utils import kvm_available, tcg_available
 
diff --git a/tests/functional/qemu_test/tuxruntest.py b/tests/functional/qemu_test/tuxruntest.py
index 6c442ff0dc4..f3b2d6e1200 100644
--- a/tests/functional/qemu_test/tuxruntest.py
+++ b/tests/functional/qemu_test/tuxruntest.py
@@ -11,10 +11,14 @@
 
 import os
 
-from qemu_test import QemuSystemTest
-from qemu_test import exec_command_and_wait_for_pattern
-from qemu_test import wait_for_console_pattern
-from qemu_test import which, get_qemu_img
+from qemu_test import (
+    QemuSystemTest,
+    exec_command_and_wait_for_pattern,
+    get_qemu_img,
+    wait_for_console_pattern,
+    which,
+)
+
 
 class TuxRunBaselineTest(QemuSystemTest):
 
diff --git a/tests/functional/qemu_test/uncompress.py b/tests/functional/qemu_test/uncompress.py
index b7ef8f759b7..83525ef6916 100644
--- a/tests/functional/qemu_test/uncompress.py
+++ b/tests/functional/qemu_test/uncompress.py
@@ -10,10 +10,10 @@
 import gzip
 import lzma
 import os
-import stat
 import shutil
+import stat
+from subprocess import CalledProcessError, run
 from urllib.parse import urlparse
-from subprocess import run, CalledProcessError
 
 from .asset import Asset
 
diff --git a/tests/functional/replay_kernel.py b/tests/functional/replay_kernel.py
index 80795eb0520..1885f4cc290 100644
--- a/tests/functional/replay_kernel.py
+++ b/tests/functional/replay_kernel.py
@@ -8,13 +8,14 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later.  See the COPYING file in the top-level directory.
 
-import os
 import logging
-import time
+import os
 import subprocess
+import time
 
 from qemu_test.linuxkernel import LinuxKernelTest
 
+
 class ReplayKernelBase(LinuxKernelTest):
     """
     Boots a Linux kernel in record mode and checks that the console
@@ -81,4 +82,4 @@ def run_rr(self, kernel_path, kernel_command_line, console_pattern,
         t2 = self.run_vm(kernel_path, kernel_command_line, console_pattern,
                          False, shift, args, replay_path)
         logger = logging.getLogger('replay')
-        logger.info('replay overhead {:.2%}'.format(t2 / t1 - 1))
+        logger.info(f'replay overhead {t2 / t1 - 1:.2%}')
diff --git a/tests/functional/reverse_debugging.py b/tests/functional/reverse_debugging.py
index f9a1d395f1d..b7630a097fb 100644
--- a/tests/functional/reverse_debugging.py
+++ b/tests/functional/reverse_debugging.py
@@ -9,8 +9,8 @@
 #
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later.  See the COPYING file in the top-level directory.
-import os
 import logging
+import os
 
 from qemu_test import LinuxKernelTest, get_qemu_img
 from qemu_test.ports import Ports
@@ -99,8 +99,7 @@ def vm_get_icount(vm):
         return vm.qmp('query-replay')['return']['icount']
 
     def reverse_debugging(self, shift=7, args=None):
-        from avocado.utils import gdb
-        from avocado.utils import process
+        from avocado.utils import gdb, process
 
         logger = logging.getLogger('replay')
 
diff --git a/tests/functional/test_aarch64_aspeed_ast2700.py b/tests/functional/test_aarch64_aspeed_ast2700.py
index d02dc7991c1..a5a25c95d0b 100755
--- a/tests/functional/test_aarch64_aspeed_ast2700.py
+++ b/tests/functional/test_aarch64_aspeed_ast2700.py
@@ -8,9 +8,12 @@
 
 import os
 
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import wait_for_console_pattern
-from qemu_test import exec_command_and_wait_for_pattern
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    exec_command_and_wait_for_pattern,
+    wait_for_console_pattern,
+)
 
 
 class AST2x00MachineSDK(QemuSystemTest):
diff --git a/tests/functional/test_aarch64_aspeed_ast2700fc.py b/tests/functional/test_aarch64_aspeed_ast2700fc.py
index b85370e182e..c85625b4527 100755
--- a/tests/functional/test_aarch64_aspeed_ast2700fc.py
+++ b/tests/functional/test_aarch64_aspeed_ast2700fc.py
@@ -8,9 +8,12 @@
 
 import os
 
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import wait_for_console_pattern
-from qemu_test import exec_command_and_wait_for_pattern
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    exec_command_and_wait_for_pattern,
+    wait_for_console_pattern,
+)
 
 
 class AST2x00MachineSDK(QemuSystemTest):
diff --git a/tests/functional/test_aarch64_imx8mp_evk.py b/tests/functional/test_aarch64_imx8mp_evk.py
index 638bf9e1310..8e5f4894579 100755
--- a/tests/functional/test_aarch64_imx8mp_evk.py
+++ b/tests/functional/test_aarch64_imx8mp_evk.py
@@ -4,7 +4,7 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
+from qemu_test import Asset, LinuxKernelTest
 
 
 class Imx8mpEvkMachine(LinuxKernelTest):
@@ -28,7 +28,7 @@ def extract(self, in_path, out_path, offset, size):
                 data = source.read(size)
             with open(out_path, "wb") as target:
                 target.write(data)
-        except (IOError, ValueError) as e:
+        except (OSError, ValueError) as e:
             self.log.error(f"Failed to extract {out_path}: {e}")
             raise
 
diff --git a/tests/functional/test_aarch64_raspi3.py b/tests/functional/test_aarch64_raspi3.py
index 74f6630ed26..cf91ff321dd 100755
--- a/tests/functional/test_aarch64_raspi3.py
+++ b/tests/functional/test_aarch64_raspi3.py
@@ -7,7 +7,7 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
+from qemu_test import Asset, LinuxKernelTest
 
 
 class Aarch64Raspi3Machine(LinuxKernelTest):
diff --git a/tests/functional/test_aarch64_raspi4.py b/tests/functional/test_aarch64_raspi4.py
index 7a4302b0c5a..6175b1347ad 100755
--- a/tests/functional/test_aarch64_raspi4.py
+++ b/tests/functional/test_aarch64_raspi4.py
@@ -5,8 +5,11 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
-from qemu_test import exec_command_and_wait_for_pattern
+from qemu_test import (
+    Asset,
+    LinuxKernelTest,
+    exec_command_and_wait_for_pattern,
+)
 
 
 class Aarch64Raspi4Machine(LinuxKernelTest):
diff --git a/tests/functional/test_aarch64_replay.py b/tests/functional/test_aarch64_replay.py
index db12e76603f..e11d0ee777e 100755
--- a/tests/functional/test_aarch64_replay.py
+++ b/tests/functional/test_aarch64_replay.py
@@ -5,9 +5,9 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from subprocess import check_call, DEVNULL
+from subprocess import DEVNULL, check_call
 
-from qemu_test import Asset, skipIfOperatingSystem, get_qemu_img
+from qemu_test import Asset, get_qemu_img, skipIfOperatingSystem
 from replay_kernel import ReplayKernelBase
 
 
diff --git a/tests/functional/test_aarch64_reverse_debug.py b/tests/functional/test_aarch64_reverse_debug.py
index 58d45328350..d7eabf837de 100755
--- a/tests/functional/test_aarch64_reverse_debug.py
+++ b/tests/functional/test_aarch64_reverse_debug.py
@@ -12,7 +12,7 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later.  See the COPYING file in the top-level directory.
 
-from qemu_test import Asset, skipIfMissingImports, skipFlakyTest
+from qemu_test import Asset, skipFlakyTest, skipIfMissingImports
 from reverse_debugging import ReverseDebugging
 
 
diff --git a/tests/functional/test_aarch64_rme_sbsaref.py b/tests/functional/test_aarch64_rme_sbsaref.py
index 746770e776d..9519d013e44 100755
--- a/tests/functional/test_aarch64_rme_sbsaref.py
+++ b/tests/functional/test_aarch64_rme_sbsaref.py
@@ -11,8 +11,12 @@
 
 import os
 
-from qemu_test import QemuSystemTest, Asset, wait_for_console_pattern
-from qemu_test import exec_command_and_wait_for_pattern
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    exec_command_and_wait_for_pattern,
+    wait_for_console_pattern,
+)
 from test_aarch64_rme_virt import test_realms_guest
 
 
diff --git a/tests/functional/test_aarch64_rme_virt.py b/tests/functional/test_aarch64_rme_virt.py
index 8452d27928f..b55c8c13168 100755
--- a/tests/functional/test_aarch64_rme_virt.py
+++ b/tests/functional/test_aarch64_rme_virt.py
@@ -11,9 +11,14 @@
 
 import os
 
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import exec_command, wait_for_console_pattern
-from qemu_test import exec_command_and_wait_for_pattern
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    exec_command,
+    exec_command_and_wait_for_pattern,
+    wait_for_console_pattern,
+)
+
 
 def test_realms_guest(test_rme_instance):
 
diff --git a/tests/functional/test_aarch64_sbsaref.py b/tests/functional/test_aarch64_sbsaref.py
index e6a55aecfac..e11fd3d4037 100755
--- a/tests/functional/test_aarch64_sbsaref.py
+++ b/tests/functional/test_aarch64_sbsaref.py
@@ -10,9 +10,12 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import wait_for_console_pattern
-from qemu_test import interrupt_interactive_console_until_pattern
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    interrupt_interactive_console_until_pattern,
+    wait_for_console_pattern,
+)
 
 
 def fetch_firmware(test):
diff --git a/tests/functional/test_aarch64_sbsaref_alpine.py b/tests/functional/test_aarch64_sbsaref_alpine.py
index 6108ec65a54..96d810a7d03 100755
--- a/tests/functional/test_aarch64_sbsaref_alpine.py
+++ b/tests/functional/test_aarch64_sbsaref_alpine.py
@@ -10,8 +10,12 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import QemuSystemTest, Asset, skipSlowTest
-from qemu_test import wait_for_console_pattern
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    skipSlowTest,
+    wait_for_console_pattern,
+)
 from test_aarch64_sbsaref import fetch_firmware
 
 
diff --git a/tests/functional/test_aarch64_sbsaref_freebsd.py b/tests/functional/test_aarch64_sbsaref_freebsd.py
index 26dfc5878bb..028483839e6 100755
--- a/tests/functional/test_aarch64_sbsaref_freebsd.py
+++ b/tests/functional/test_aarch64_sbsaref_freebsd.py
@@ -10,8 +10,12 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import QemuSystemTest, Asset, skipSlowTest
-from qemu_test import wait_for_console_pattern
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    skipSlowTest,
+    wait_for_console_pattern,
+)
 from test_aarch64_sbsaref import fetch_firmware
 
 
diff --git a/tests/functional/test_aarch64_smmu.py b/tests/functional/test_aarch64_smmu.py
index c65d0f28178..d95c6d60a33 100755
--- a/tests/functional/test_aarch64_smmu.py
+++ b/tests/functional/test_aarch64_smmu.py
@@ -15,9 +15,13 @@
 import os
 import time
 
-from qemu_test import LinuxKernelTest, Asset, exec_command_and_wait_for_pattern
-from qemu_test import BUILD_DIR
 from qemu.utils import kvm_available
+from qemu_test import (
+    BUILD_DIR,
+    Asset,
+    LinuxKernelTest,
+    exec_command_and_wait_for_pattern,
+)
 
 
 class SMMU(LinuxKernelTest):
diff --git a/tests/functional/test_aarch64_tcg_plugins.py b/tests/functional/test_aarch64_tcg_plugins.py
index cb7e9298fb8..0e41ed1f13c 100755
--- a/tests/functional/test_aarch64_tcg_plugins.py
+++ b/tests/functional/test_aarch64_tcg_plugins.py
@@ -11,12 +11,12 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-import tempfile
 import mmap
 import re
+import tempfile
 
 from qemu.machine.machine import VMLaunchFailure
-from qemu_test import LinuxKernelTest, Asset
+from qemu_test import Asset, LinuxKernelTest
 
 
 class PluginKernelBase(LinuxKernelTest):
diff --git a/tests/functional/test_aarch64_tuxrun.py b/tests/functional/test_aarch64_tuxrun.py
index 75adc8acb83..dcafbf43098 100755
--- a/tests/functional/test_aarch64_tuxrun.py
+++ b/tests/functional/test_aarch64_tuxrun.py
@@ -14,6 +14,7 @@
 from qemu_test import Asset
 from qemu_test.tuxruntest import TuxRunBaselineTest
 
+
 class TuxRunAarch64Test(TuxRunBaselineTest):
 
     ASSET_ARM64_KERNEL = Asset(
diff --git a/tests/functional/test_aarch64_virt.py b/tests/functional/test_aarch64_virt.py
index 4d0ad90ff89..f4414f29714 100755
--- a/tests/functional/test_aarch64_virt.py
+++ b/tests/functional/test_aarch64_virt.py
@@ -11,10 +11,15 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
 import logging
-from subprocess import check_call, DEVNULL
+from subprocess import DEVNULL, check_call
 
-from qemu_test import QemuSystemTest, Asset, exec_command_and_wait_for_pattern
-from qemu_test import wait_for_console_pattern, get_qemu_img
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    exec_command_and_wait_for_pattern,
+    get_qemu_img,
+    wait_for_console_pattern,
+)
 
 
 class Aarch64VirtMachine(QemuSystemTest):
diff --git a/tests/functional/test_aarch64_virt_gpu.py b/tests/functional/test_aarch64_virt_gpu.py
index 38447278579..7dab6317f1c 100755
--- a/tests/functional/test_aarch64_virt_gpu.py
+++ b/tests/functional/test_aarch64_virt_gpu.py
@@ -9,16 +9,15 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
+from re import search
+from subprocess import CalledProcessError, check_output
+
 from qemu.machine.machine import VMLaunchFailure
-
 from qemu_test import Asset
 from qemu_test import exec_command_and_wait_for_pattern as ec_and_wait
 from qemu_test import skipIfMissingCommands
-
 from qemu_test.linuxkernel import LinuxKernelTest
 
-from re import search
-from subprocess import check_output, CalledProcessError
 
 class Aarch64VirtGPUMachine(LinuxKernelTest):
 
diff --git a/tests/functional/test_aarch64_xlnx_versal.py b/tests/functional/test_aarch64_xlnx_versal.py
index 4b9c49e5d64..b7da7800c49 100755
--- a/tests/functional/test_aarch64_xlnx_versal.py
+++ b/tests/functional/test_aarch64_xlnx_versal.py
@@ -4,7 +4,8 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
+from qemu_test import Asset, LinuxKernelTest
+
 
 class XlnxVersalVirtMachine(LinuxKernelTest):
 
diff --git a/tests/functional/test_acpi_bits.py b/tests/functional/test_acpi_bits.py
index 8e0563a97b1..b6bb92135d5 100755
--- a/tests/functional/test_acpi_bits.py
+++ b/tests/functional/test_acpi_bits.py
@@ -31,19 +31,20 @@
 https://gitlab.com/qemu-project/biosbits-bits .
 """
 
+from collections.abc import Sequence
 import os
 import re
 import shutil
 import subprocess
+from typing import Optional
 
-from typing import (
-    List,
-    Optional,
-    Sequence,
-)
 from qemu.machine import QEMUMachine
-from qemu_test import (QemuSystemTest, Asset, skipIfMissingCommands,
-                       skipIfNotMachine)
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    skipIfMissingCommands,
+    skipIfNotMachine,
+)
 
 
 # default timeout of 120 secs is sometimes not enough for bits test.
@@ -76,7 +77,7 @@ def __init__(self,
         self.base_temp_dir = base_temp_dir
 
     @property
-    def _base_args(self) -> List[str]:
+    def _base_args(self) -> list[str]:
         args = super()._base_args
         args.extend([
             '-chardev',
@@ -190,7 +191,7 @@ def fix_mkrescue(self, mkrescue):
         self.assertTrue(os.path.exists(grub_i386_mods))
 
         new_script = ""
-        with open(mkrescue, 'r', encoding='utf-8') as filehandle:
+        with open(mkrescue, encoding='utf-8') as filehandle:
             orig_script = filehandle.read()
             new_script = re.sub('(^prefix=)(.*)',
                                 r'\1"%s"' %grub_x86_64_mods,
@@ -274,7 +275,7 @@ def parse_log(self):
         """
         debugconf = self.scratch_file(self._debugcon_log)
         log = ""
-        with open(debugconf, 'r', encoding='utf-8') as filehandle:
+        with open(debugconf, encoding='utf-8') as filehandle:
             log = filehandle.read()
 
         matchiter = re.finditer(r'(.*Summary: )(\d+ passed), (\d+ failed).*',
diff --git a/tests/functional/test_alpha_clipper.py b/tests/functional/test_alpha_clipper.py
index c5d71819531..526684e9ba2 100755
--- a/tests/functional/test_alpha_clipper.py
+++ b/tests/functional/test_alpha_clipper.py
@@ -5,7 +5,7 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
+from qemu_test import Asset, LinuxKernelTest
 
 
 class AlphaClipperTest(LinuxKernelTest):
diff --git a/tests/functional/test_arm_aspeed_ast1030.py b/tests/functional/test_arm_aspeed_ast1030.py
index 77037f01793..42fff946eb6 100755
--- a/tests/functional/test_arm_aspeed_ast1030.py
+++ b/tests/functional/test_arm_aspeed_ast1030.py
@@ -6,8 +6,11 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
-from qemu_test import exec_command_and_wait_for_pattern
+from qemu_test import (
+    Asset,
+    LinuxKernelTest,
+    exec_command_and_wait_for_pattern,
+)
 
 
 class AST1030Machine(LinuxKernelTest):
diff --git a/tests/functional/test_arm_aspeed_ast2500.py b/tests/functional/test_arm_aspeed_ast2500.py
index 6923fe87017..56190eaf4d2 100755
--- a/tests/functional/test_arm_aspeed_ast2500.py
+++ b/tests/functional/test_arm_aspeed_ast2500.py
@@ -4,8 +4,8 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import Asset, exec_command_and_wait_for_pattern
 from aspeed import AspeedTest
+from qemu_test import Asset, exec_command_and_wait_for_pattern
 
 
 class AST2500Machine(AspeedTest):
diff --git a/tests/functional/test_arm_aspeed_ast2600.py b/tests/functional/test_arm_aspeed_ast2600.py
index fdae4c939d8..afa2f235dc3 100755
--- a/tests/functional/test_arm_aspeed_ast2600.py
+++ b/tests/functional/test_arm_aspeed_ast2600.py
@@ -5,13 +5,16 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
 import os
-import time
-import tempfile
 import subprocess
+import tempfile
+import time
 
-from qemu_test import Asset
 from aspeed import AspeedTest
-from qemu_test import exec_command_and_wait_for_pattern, skipIfMissingCommands
+from qemu_test import (
+    Asset,
+    exec_command_and_wait_for_pattern,
+    skipIfMissingCommands,
+)
 
 
 class AST2600Machine(AspeedTest):
diff --git a/tests/functional/test_arm_aspeed_bletchley.py b/tests/functional/test_arm_aspeed_bletchley.py
index 5a60b24b3d2..1937719d7f6 100644
--- a/tests/functional/test_arm_aspeed_bletchley.py
+++ b/tests/functional/test_arm_aspeed_bletchley.py
@@ -4,8 +4,8 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import Asset
 from aspeed import AspeedTest
+from qemu_test import Asset
 
 
 class BletchleyMachine(AspeedTest):
diff --git a/tests/functional/test_arm_aspeed_palmetto.py b/tests/functional/test_arm_aspeed_palmetto.py
index ff0b821be65..78ef060def7 100755
--- a/tests/functional/test_arm_aspeed_palmetto.py
+++ b/tests/functional/test_arm_aspeed_palmetto.py
@@ -4,8 +4,8 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import Asset
 from aspeed import AspeedTest
+from qemu_test import Asset
 
 
 class PalmettoMachine(AspeedTest):
diff --git a/tests/functional/test_arm_aspeed_rainier.py b/tests/functional/test_arm_aspeed_rainier.py
index 602d6194ac8..b97395668b8 100755
--- a/tests/functional/test_arm_aspeed_rainier.py
+++ b/tests/functional/test_arm_aspeed_rainier.py
@@ -4,8 +4,9 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import Asset
 from aspeed import AspeedTest
+from qemu_test import Asset
+
 
 class RainierMachine(AspeedTest):
 
diff --git a/tests/functional/test_arm_aspeed_romulus.py b/tests/functional/test_arm_aspeed_romulus.py
index 0447212bbf0..8d2a5b32b68 100755
--- a/tests/functional/test_arm_aspeed_romulus.py
+++ b/tests/functional/test_arm_aspeed_romulus.py
@@ -4,8 +4,8 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import Asset
 from aspeed import AspeedTest
+from qemu_test import Asset
 
 
 class RomulusMachine(AspeedTest):
diff --git a/tests/functional/test_arm_aspeed_witherspoon.py b/tests/functional/test_arm_aspeed_witherspoon.py
index 51a2d47af28..4b2c2f797c9 100644
--- a/tests/functional/test_arm_aspeed_witherspoon.py
+++ b/tests/functional/test_arm_aspeed_witherspoon.py
@@ -4,8 +4,8 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import Asset
 from aspeed import AspeedTest
+from qemu_test import Asset
 
 
 class WitherspoonMachine(AspeedTest):
diff --git a/tests/functional/test_arm_bflt.py b/tests/functional/test_arm_bflt.py
index f273fc83546..0ce035c5c93 100755
--- a/tests/functional/test_arm_bflt.py
+++ b/tests/functional/test_arm_bflt.py
@@ -8,8 +8,12 @@
 
 import bz2
 
-from qemu_test import QemuUserTest, Asset
-from qemu_test import skipIfMissingCommands, skipUntrustedTest
+from qemu_test import (
+    Asset,
+    QemuUserTest,
+    skipIfMissingCommands,
+    skipUntrustedTest,
+)
 
 
 class LoadBFLT(QemuUserTest):
diff --git a/tests/functional/test_arm_bpim2u.py b/tests/functional/test_arm_bpim2u.py
index 8bed64b702f..ccd74948c87 100755
--- a/tests/functional/test_arm_bpim2u.py
+++ b/tests/functional/test_arm_bpim2u.py
@@ -7,9 +7,13 @@
 
 import os
 
-from qemu_test import LinuxKernelTest, exec_command_and_wait_for_pattern
-from qemu_test import Asset, interrupt_interactive_console_until_pattern
-from qemu_test import skipBigDataTest
+from qemu_test import (
+    Asset,
+    LinuxKernelTest,
+    exec_command_and_wait_for_pattern,
+    interrupt_interactive_console_until_pattern,
+    skipBigDataTest,
+)
 from qemu_test.utils import image_pow2ceil_expand
 
 
diff --git a/tests/functional/test_arm_canona1100.py b/tests/functional/test_arm_canona1100.py
index 21a1a596a0c..a4bfdfe57d7 100755
--- a/tests/functional/test_arm_canona1100.py
+++ b/tests/functional/test_arm_canona1100.py
@@ -10,8 +10,7 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later.  See the COPYING file in the top-level directory.
 
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import wait_for_console_pattern
+from qemu_test import Asset, QemuSystemTest, wait_for_console_pattern
 
 
 class CanonA1100Machine(QemuSystemTest):
diff --git a/tests/functional/test_arm_collie.py b/tests/functional/test_arm_collie.py
index fe1be3d0792..eefea3f4c10 100755
--- a/tests/functional/test_arm_collie.py
+++ b/tests/functional/test_arm_collie.py
@@ -5,7 +5,7 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
+from qemu_test import Asset, LinuxKernelTest
 
 
 class CollieTest(LinuxKernelTest):
diff --git a/tests/functional/test_arm_cubieboard.py b/tests/functional/test_arm_cubieboard.py
index b536c2f77a0..37c6a28ee6f 100755
--- a/tests/functional/test_arm_cubieboard.py
+++ b/tests/functional/test_arm_cubieboard.py
@@ -4,9 +4,13 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset, exec_command_and_wait_for_pattern
-from qemu_test import interrupt_interactive_console_until_pattern
-from qemu_test import skipBigDataTest
+from qemu_test import (
+    Asset,
+    LinuxKernelTest,
+    exec_command_and_wait_for_pattern,
+    interrupt_interactive_console_until_pattern,
+    skipBigDataTest,
+)
 from qemu_test.utils import image_pow2ceil_expand
 
 
diff --git a/tests/functional/test_arm_emcraft_sf2.py b/tests/functional/test_arm_emcraft_sf2.py
index f9f3f069e2c..d9de3a7f9de 100755
--- a/tests/functional/test_arm_emcraft_sf2.py
+++ b/tests/functional/test_arm_emcraft_sf2.py
@@ -7,9 +7,14 @@
 import os
 import shutil
 
-from qemu_test import LinuxKernelTest, Asset, exec_command_and_wait_for_pattern
+from qemu_test import (
+    Asset,
+    LinuxKernelTest,
+    exec_command_and_wait_for_pattern,
+)
 from qemu_test.utils import file_truncate
 
+
 class EmcraftSf2Machine(LinuxKernelTest):
 
     ASSET_UBOOT = Asset(
diff --git a/tests/functional/test_arm_integratorcp.py b/tests/functional/test_arm_integratorcp.py
index 4f00924aa03..4a240a0b0ba 100755
--- a/tests/functional/test_arm_integratorcp.py
+++ b/tests/functional/test_arm_integratorcp.py
@@ -14,9 +14,13 @@
 
 import logging
 
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import wait_for_console_pattern
-from qemu_test import skipIfMissingImports, skipUntrustedTest
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    skipIfMissingImports,
+    skipUntrustedTest,
+    wait_for_console_pattern,
+)
 
 
 class IntegratorMachine(QemuSystemTest):
@@ -63,8 +67,8 @@ def test_framebuffer_tux_logo(self):
         """
         Boot Linux and verify the Tux logo is displayed on the framebuffer.
         """
-        import numpy as np
         import cv2
+        import numpy as np
 
         screendump_path = self.scratch_file("screendump.pbm")
         tuxlogo_path = self.ASSET_TUXLOGO.fetch()
diff --git a/tests/functional/test_arm_microbit.py b/tests/functional/test_arm_microbit.py
index 68ea4e73d62..fe29a4d9970 100755
--- a/tests/functional/test_arm_microbit.py
+++ b/tests/functional/test_arm_microbit.py
@@ -6,8 +6,12 @@
 #
 # A functional test that runs MicroPython on the arm microbit machine.
 
-from qemu_test import QemuSystemTest, Asset, exec_command_and_wait_for_pattern
-from qemu_test import wait_for_console_pattern
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    exec_command_and_wait_for_pattern,
+    wait_for_console_pattern,
+)
 
 
 class MicrobitMachine(QemuSystemTest):
diff --git a/tests/functional/test_arm_orangepi.py b/tests/functional/test_arm_orangepi.py
index f9bfa8c78d9..2c36e4e0b9d 100755
--- a/tests/functional/test_arm_orangepi.py
+++ b/tests/functional/test_arm_orangepi.py
@@ -8,9 +8,14 @@
 import os
 import shutil
 
-from qemu_test import LinuxKernelTest, exec_command_and_wait_for_pattern
-from qemu_test import Asset, interrupt_interactive_console_until_pattern
-from qemu_test import wait_for_console_pattern, skipBigDataTest
+from qemu_test import (
+    Asset,
+    LinuxKernelTest,
+    exec_command_and_wait_for_pattern,
+    interrupt_interactive_console_until_pattern,
+    skipBigDataTest,
+    wait_for_console_pattern,
+)
 from qemu_test.utils import image_pow2ceil_expand
 
 
diff --git a/tests/functional/test_arm_quanta_gsj.py b/tests/functional/test_arm_quanta_gsj.py
index cb0545f7bfa..2b37d898e2d 100755
--- a/tests/functional/test_arm_quanta_gsj.py
+++ b/tests/functional/test_arm_quanta_gsj.py
@@ -4,8 +4,13 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset, exec_command_and_wait_for_pattern
-from qemu_test import interrupt_interactive_console_until_pattern, skipSlowTest
+from qemu_test import (
+    Asset,
+    LinuxKernelTest,
+    exec_command_and_wait_for_pattern,
+    interrupt_interactive_console_until_pattern,
+    skipSlowTest,
+)
 
 
 class EmcraftSf2Machine(LinuxKernelTest):
diff --git a/tests/functional/test_arm_raspi2.py b/tests/functional/test_arm_raspi2.py
index d3c7aaa39b0..3ef95f9cb73 100755
--- a/tests/functional/test_arm_raspi2.py
+++ b/tests/functional/test_arm_raspi2.py
@@ -7,8 +7,11 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
-from qemu_test import exec_command_and_wait_for_pattern
+from qemu_test import (
+    Asset,
+    LinuxKernelTest,
+    exec_command_and_wait_for_pattern,
+)
 
 
 class ArmRaspi2Machine(LinuxKernelTest):
diff --git a/tests/functional/test_arm_smdkc210.py b/tests/functional/test_arm_smdkc210.py
index 3154e7f7322..69c5ab24718 100755
--- a/tests/functional/test_arm_smdkc210.py
+++ b/tests/functional/test_arm_smdkc210.py
@@ -4,7 +4,7 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
+from qemu_test import Asset, LinuxKernelTest
 
 
 class Smdkc210Machine(LinuxKernelTest):
diff --git a/tests/functional/test_arm_stellaris.py b/tests/functional/test_arm_stellaris.py
index cbd21cb1a0b..1d9f23c98e6 100755
--- a/tests/functional/test_arm_stellaris.py
+++ b/tests/functional/test_arm_stellaris.py
@@ -4,8 +4,12 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import QemuSystemTest, Asset, exec_command_and_wait_for_pattern
-from qemu_test import wait_for_console_pattern
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    exec_command_and_wait_for_pattern,
+    wait_for_console_pattern,
+)
 
 
 class StellarisMachine(QemuSystemTest):
diff --git a/tests/functional/test_arm_sx1.py b/tests/functional/test_arm_sx1.py
index 25800b388c9..dc6d8a0ca12 100755
--- a/tests/functional/test_arm_sx1.py
+++ b/tests/functional/test_arm_sx1.py
@@ -13,7 +13,7 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
+from qemu_test import Asset, LinuxKernelTest
 
 
 class SX1Test(LinuxKernelTest):
diff --git a/tests/functional/test_arm_tuxrun.py b/tests/functional/test_arm_tuxrun.py
index 4ac85f48ac1..32d880ae4d6 100755
--- a/tests/functional/test_arm_tuxrun.py
+++ b/tests/functional/test_arm_tuxrun.py
@@ -14,6 +14,7 @@
 from qemu_test import Asset
 from qemu_test.tuxruntest import TuxRunBaselineTest
 
+
 class TuxRunArmTest(TuxRunBaselineTest):
 
     ASSET_ARMV5_KERNEL = Asset(
diff --git a/tests/functional/test_arm_vexpress.py b/tests/functional/test_arm_vexpress.py
index 6b115528947..0410c1581d8 100755
--- a/tests/functional/test_arm_vexpress.py
+++ b/tests/functional/test_arm_vexpress.py
@@ -5,7 +5,7 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
+from qemu_test import Asset, LinuxKernelTest
 
 
 class VExpressTest(LinuxKernelTest):
diff --git a/tests/functional/test_arm_virt.py b/tests/functional/test_arm_virt.py
index 7b6549176f5..3936b750964 100755
--- a/tests/functional/test_arm_virt.py
+++ b/tests/functional/test_arm_virt.py
@@ -4,7 +4,8 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
+from qemu_test import Asset, LinuxKernelTest
+
 
 class ArmVirtMachine(LinuxKernelTest):
 
diff --git a/tests/functional/test_avr_mega2560.py b/tests/functional/test_avr_mega2560.py
index 6359b72af39..d0bac2a8062 100755
--- a/tests/functional/test_avr_mega2560.py
+++ b/tests/functional/test_avr_mega2560.py
@@ -18,7 +18,7 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-from qemu_test import QemuSystemTest, Asset, wait_for_console_pattern
+from qemu_test import Asset, QemuSystemTest, wait_for_console_pattern
 
 
 class AVR6Machine(QemuSystemTest):
diff --git a/tests/functional/test_avr_uno.py b/tests/functional/test_avr_uno.py
index adb3b73da4f..034c1010181 100755
--- a/tests/functional/test_avr_uno.py
+++ b/tests/functional/test_avr_uno.py
@@ -4,7 +4,7 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import QemuSystemTest, Asset, wait_for_console_pattern
+from qemu_test import Asset, QemuSystemTest, wait_for_console_pattern
 
 
 class UnoMachine(QemuSystemTest):
diff --git a/tests/functional/test_cpu_queries.py b/tests/functional/test_cpu_queries.py
index b1122a0e8f7..66314ab2689 100755
--- a/tests/functional/test_cpu_queries.py
+++ b/tests/functional/test_cpu_queries.py
@@ -12,6 +12,7 @@
 
 from qemu_test import QemuSystemTest
 
+
 class QueryCPUModelExpansion(QemuSystemTest):
     """
     Run query-cpu-model-expansion for each CPU model, and validate results
diff --git a/tests/functional/test_empty_cpu_model.py b/tests/functional/test_empty_cpu_model.py
index 0081b06d85a..b1a563671cf 100755
--- a/tests/functional/test_empty_cpu_model.py
+++ b/tests/functional/test_empty_cpu_model.py
@@ -11,6 +11,7 @@
 # later.  See the COPYING file in the top-level directory.
 from qemu_test import QemuSystemTest
 
+
 class EmptyCPUModel(QemuSystemTest):
     def test(self):
         self.vm.add_args('-S', '-display', 'none', '-machine', 'none', '-cpu', '')
diff --git a/tests/functional/test_hppa_seabios.py b/tests/functional/test_hppa_seabios.py
index 661b2464e13..b8c7d7c61ec 100755
--- a/tests/functional/test_hppa_seabios.py
+++ b/tests/functional/test_hppa_seabios.py
@@ -6,8 +6,8 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import QemuSystemTest
-from qemu_test import wait_for_console_pattern
+from qemu_test import QemuSystemTest, wait_for_console_pattern
+
 
 class HppaSeabios(QemuSystemTest):
 
diff --git a/tests/functional/test_i386_tuxrun.py b/tests/functional/test_i386_tuxrun.py
index f3ccf11ae8b..5c89a4840a5 100755
--- a/tests/functional/test_i386_tuxrun.py
+++ b/tests/functional/test_i386_tuxrun.py
@@ -14,6 +14,7 @@
 from qemu_test import Asset
 from qemu_test.tuxruntest import TuxRunBaselineTest
 
+
 class TuxRunI386Test(TuxRunBaselineTest):
 
     ASSET_I386_KERNEL = Asset(
diff --git a/tests/functional/test_intel_iommu.py b/tests/functional/test_intel_iommu.py
index 62268d6f278..54b7e23781a 100755
--- a/tests/functional/test_intel_iommu.py
+++ b/tests/functional/test_intel_iommu.py
@@ -10,7 +10,11 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later.  See the COPYING file in the top-level directory.
 
-from qemu_test import LinuxKernelTest, Asset, exec_command_and_wait_for_pattern
+from qemu_test import (
+    Asset,
+    LinuxKernelTest,
+    exec_command_and_wait_for_pattern,
+)
 
 
 class IntelIOMMU(LinuxKernelTest):
diff --git a/tests/functional/test_linux_initrd.py b/tests/functional/test_linux_initrd.py
index 2207f83fbfd..ebd0f120f9d 100755
--- a/tests/functional/test_linux_initrd.py
+++ b/tests/functional/test_linux_initrd.py
@@ -13,7 +13,7 @@
 import logging
 import tempfile
 
-from qemu_test import QemuSystemTest, Asset, skipFlakyTest
+from qemu_test import Asset, QemuSystemTest, skipFlakyTest
 
 
 class LinuxInitrd(QemuSystemTest):
diff --git a/tests/functional/test_loongarch64_virt.py b/tests/functional/test_loongarch64_virt.py
index b7d9abf933f..472276b4520 100755
--- a/tests/functional/test_loongarch64_virt.py
+++ b/tests/functional/test_loongarch64_virt.py
@@ -7,9 +7,13 @@
 # Copyright (c) 2023 Loongson Technology Corporation Limited
 #
 
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import exec_command_and_wait_for_pattern
-from qemu_test import wait_for_console_pattern
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    exec_command_and_wait_for_pattern,
+    wait_for_console_pattern,
+)
+
 
 class LoongArchMachine(QemuSystemTest):
     KERNEL_COMMON_COMMAND_LINE = 'printk.time=0 '
diff --git a/tests/functional/test_m68k_mcf5208evb.py b/tests/functional/test_m68k_mcf5208evb.py
index c7d19989334..98574e2f699 100755
--- a/tests/functional/test_m68k_mcf5208evb.py
+++ b/tests/functional/test_m68k_mcf5208evb.py
@@ -5,7 +5,7 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
+from qemu_test import Asset, LinuxKernelTest
 
 
 class Mcf5208EvbTest(LinuxKernelTest):
diff --git a/tests/functional/test_m68k_nextcube.py b/tests/functional/test_m68k_nextcube.py
index 13c72bd136a..e141fe6d017 100755
--- a/tests/functional/test_m68k_nextcube.py
+++ b/tests/functional/test_m68k_nextcube.py
@@ -9,8 +9,12 @@
 
 import time
 
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import skipIfMissingImports, skipIfMissingCommands
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    skipIfMissingCommands,
+    skipIfMissingImports,
+)
 from qemu_test.tesseract import tesseract_ocr
 
 
diff --git a/tests/functional/test_m68k_q800.py b/tests/functional/test_m68k_q800.py
index b3e655346c4..c8eacc9dab9 100755
--- a/tests/functional/test_m68k_q800.py
+++ b/tests/functional/test_m68k_q800.py
@@ -5,7 +5,8 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later.  See the COPYING file in the top-level directory.
 
-from qemu_test import LinuxKernelTest, Asset
+from qemu_test import Asset, LinuxKernelTest
+
 
 class Q800MachineTest(LinuxKernelTest):
 
diff --git a/tests/functional/test_m68k_tuxrun.py b/tests/functional/test_m68k_tuxrun.py
index 7eacba135f6..421b39beba0 100755
--- a/tests/functional/test_m68k_tuxrun.py
+++ b/tests/functional/test_m68k_tuxrun.py
@@ -14,6 +14,7 @@
 from qemu_test import Asset
 from qemu_test.tuxruntest import TuxRunBaselineTest
 
+
 class TuxRunM68KTest(TuxRunBaselineTest):
 
     ASSET_M68K_KERNEL = Asset(
diff --git a/tests/functional/test_mem_addr_space.py b/tests/functional/test_mem_addr_space.py
index 61b4a190b41..a556e4ee30a 100755
--- a/tests/functional/test_mem_addr_space.py
+++ b/tests/functional/test_mem_addr_space.py
@@ -10,9 +10,11 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import QemuSystemTest
 import time
 
+from qemu_test import QemuSystemTest
+
+
 class MemAddrCheck(QemuSystemTest):
     # after launch, in order to generate the logs from QEMU we need to
     # wait for some time. Launching and then immediately shutting down
diff --git a/tests/functional/test_memlock.py b/tests/functional/test_memlock.py
index 2b515ff979f..dd27170b4c3 100755
--- a/tests/functional/test_memlock.py
+++ b/tests/functional/test_memlock.py
@@ -11,10 +11,7 @@
 
 import re
 
-from typing import Dict
-
-from qemu_test import QemuSystemTest
-from qemu_test import skipLockedMemoryTest
+from qemu_test import QemuSystemTest, skipLockedMemoryTest
 
 
 STATUS_VALUE_PATTERN = re.compile(r'^(\w+):\s+(\d+) kB', re.MULTILINE)
@@ -57,7 +54,7 @@ def test_memlock_onfault(self):
         self.assertTrue(status['VmLck'] > 0)
         self.assertTrue(status['VmRSS'] <= status['VmSize'] * 0.30)
 
-    def get_process_status_values(self, pid: int) -> Dict[str, int]:
+    def get_process_status_values(self, pid: int) -> dict[str, int]:
         result = {}
         raw_status = self._get_raw_process_status(pid)
 
@@ -69,7 +66,7 @@ def get_process_status_values(self, pid: int) -> Dict[str, int]:
 
     def _get_raw_process_status(self, pid: int) -> str:
         try:
-            with open(f'/proc/{pid}/status', 'r') as f:
+            with open(f'/proc/{pid}/status') as f:
                 return f.read()
         except FileNotFoundError:
             self.skipTest("Can't open status file of the process")
diff --git a/tests/functional/test_microblaze_s3adsp1800.py b/tests/functional/test_microblaze_s3adsp1800.py
index f093b162c0a..7fa175c9684 100755
--- a/tests/functional/test_microblaze_s3adsp1800.py
+++ b/tests/functional/test_microblaze_s3adsp1800.py
@@ -7,9 +7,12 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later. See the COPYING file in the top-level directory.
 
-from qemu_test import exec_command_and_wait_for_pattern
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import wait_for_console_pattern
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    exec_command_and_wait_for_pattern,
+    wait_for_console_pattern,
+)
 
 
 class MicroblazeMachine(QemuSystemTest):
diff --git a/tests/functional/test_mips64_malta.py b/tests/functional/test_mips64_malta.py
index 53c3e0c1221..80f961d65d8 100755
--- a/tests/functional/test_mips64_malta.py
+++ b/tests/functional/test_mips64_malta.py
@@ -4,7 +4,7 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
+from qemu_test import Asset, LinuxKernelTest
 from test_mips_malta import mips_check_wheezy
 
 
diff --git a/tests/functional/test_mips64_tuxrun.py b/tests/functional/test_mips64_tuxrun.py
index 0e4c65961d2..bd8089d293d 100755
--- a/tests/functional/test_mips64_tuxrun.py
+++ b/tests/functional/test_mips64_tuxrun.py
@@ -14,6 +14,7 @@
 from qemu_test import Asset
 from qemu_test.tuxruntest import TuxRunBaselineTest
 
+
 class TuxRunMips64Test(TuxRunBaselineTest):
 
     ASSET_MIPS64_KERNEL = Asset(
diff --git a/tests/functional/test_mips64el_fuloong2e.py b/tests/functional/test_mips64el_fuloong2e.py
index 35e500b0221..adbdc602485 100755
--- a/tests/functional/test_mips64el_fuloong2e.py
+++ b/tests/functional/test_mips64el_fuloong2e.py
@@ -11,11 +11,16 @@
 
 import os
 import subprocess
-
-from qemu_test import LinuxKernelTest, Asset
-from qemu_test import wait_for_console_pattern, skipUntrustedTest
 from unittest import skipUnless
 
+from qemu_test import (
+    Asset,
+    LinuxKernelTest,
+    skipUntrustedTest,
+    wait_for_console_pattern,
+)
+
+
 class MipsFuloong2e(LinuxKernelTest):
 
     timeout = 60
diff --git a/tests/functional/test_mips64el_loongson3v.py b/tests/functional/test_mips64el_loongson3v.py
index f85371e50cd..89a94bc138d 100755
--- a/tests/functional/test_mips64el_loongson3v.py
+++ b/tests/functional/test_mips64el_loongson3v.py
@@ -9,8 +9,12 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import wait_for_console_pattern, skipUntrustedTest
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    skipUntrustedTest,
+    wait_for_console_pattern,
+)
 
 
 class MipsLoongson3v(QemuSystemTest):
diff --git a/tests/functional/test_mips64el_malta.py b/tests/functional/test_mips64el_malta.py
index 3cc79b74c18..5cf61fa04ed 100755
--- a/tests/functional/test_mips64el_malta.py
+++ b/tests/functional/test_mips64el_malta.py
@@ -9,13 +9,17 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-import os
 import logging
+import os
 
-from qemu_test import LinuxKernelTest, Asset
-from qemu_test import exec_command_and_wait_for_pattern
-from qemu_test import skipIfMissingImports, skipFlakyTest, skipUntrustedTest
-
+from qemu_test import (
+    Asset,
+    LinuxKernelTest,
+    exec_command_and_wait_for_pattern,
+    skipFlakyTest,
+    skipIfMissingImports,
+    skipUntrustedTest,
+)
 from test_mips_malta import mips_check_wheezy
 
 
@@ -133,8 +137,8 @@ def do_test_i6400_framebuffer_logo(self, cpu_cores_count):
         Boot Linux kernel and check Tux logo is displayed on the framebuffer.
         """
 
-        import numpy as np
         import cv2
+        import numpy as np
 
         screendump_path = self.scratch_file('screendump.pbm')
 
@@ -193,5 +197,6 @@ def test_mips_malta_i6400_framebuffer_logo_8cores(self):
 
 from test_mipsel_malta import MaltaMachineYAMON
 
+
 if __name__ == '__main__':
     LinuxKernelTest.main()
diff --git a/tests/functional/test_mips64el_tuxrun.py b/tests/functional/test_mips64el_tuxrun.py
index 0a24757c518..8b286cd7a94 100755
--- a/tests/functional/test_mips64el_tuxrun.py
+++ b/tests/functional/test_mips64el_tuxrun.py
@@ -14,6 +14,7 @@
 from qemu_test import Asset
 from qemu_test.tuxruntest import TuxRunBaselineTest
 
+
 class TuxRunMips64ELTest(TuxRunBaselineTest):
 
     ASSET_MIPS64EL_KERNEL = Asset(
diff --git a/tests/functional/test_mips_malta.py b/tests/functional/test_mips_malta.py
index 30279f0ff21..0c9f9d75327 100755
--- a/tests/functional/test_mips_malta.py
+++ b/tests/functional/test_mips_malta.py
@@ -8,8 +8,12 @@
 
 import os
 
-from qemu_test import LinuxKernelTest, Asset, wait_for_console_pattern
-from qemu_test import exec_command_and_wait_for_pattern
+from qemu_test import (
+    Asset,
+    LinuxKernelTest,
+    exec_command_and_wait_for_pattern,
+    wait_for_console_pattern,
+)
 
 
 def mips_run_common_commands(test, prompt='#'):
diff --git a/tests/functional/test_mips_tuxrun.py b/tests/functional/test_mips_tuxrun.py
index 6771dbd57ea..0d050fc06af 100755
--- a/tests/functional/test_mips_tuxrun.py
+++ b/tests/functional/test_mips_tuxrun.py
@@ -14,6 +14,7 @@
 from qemu_test import Asset
 from qemu_test.tuxruntest import TuxRunBaselineTest
 
+
 class TuxRunMipsTest(TuxRunBaselineTest):
 
     ASSET_MIPS_KERNEL = Asset(
diff --git a/tests/functional/test_mipsel_malta.py b/tests/functional/test_mipsel_malta.py
index 9ee2884da8e..8229a0f84e8 100755
--- a/tests/functional/test_mipsel_malta.py
+++ b/tests/functional/test_mipsel_malta.py
@@ -9,10 +9,13 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import QemuSystemTest, LinuxKernelTest, Asset
-from qemu_test import interrupt_interactive_console_until_pattern
-from qemu_test import wait_for_console_pattern
-
+from qemu_test import (
+    Asset,
+    LinuxKernelTest,
+    QemuSystemTest,
+    interrupt_interactive_console_until_pattern,
+    wait_for_console_pattern,
+)
 from test_mips_malta import mips_check_wheezy
 
 
diff --git a/tests/functional/test_mipsel_tuxrun.py b/tests/functional/test_mipsel_tuxrun.py
index d4b39baab59..ff908b5039d 100755
--- a/tests/functional/test_mipsel_tuxrun.py
+++ b/tests/functional/test_mipsel_tuxrun.py
@@ -14,6 +14,7 @@
 from qemu_test import Asset
 from qemu_test.tuxruntest import TuxRunBaselineTest
 
+
 class TuxRunMipsELTest(TuxRunBaselineTest):
 
     ASSET_MIPSEL_KERNEL = Asset(
diff --git a/tests/functional/test_multiprocess.py b/tests/functional/test_multiprocess.py
index 751cf10e635..5efa1c8ecdb 100755
--- a/tests/functional/test_multiprocess.py
+++ b/tests/functional/test_multiprocess.py
@@ -9,8 +9,14 @@
 import os
 import socket
 
-from qemu_test import QemuSystemTest, Asset, wait_for_console_pattern
-from qemu_test import exec_command, exec_command_and_wait_for_pattern
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    exec_command,
+    exec_command_and_wait_for_pattern,
+    wait_for_console_pattern,
+)
+
 
 class Multiprocess(QemuSystemTest):
 
diff --git a/tests/functional/test_netdev_ethtool.py b/tests/functional/test_netdev_ethtool.py
index ee1a397bd24..9b9d253da75 100755
--- a/tests/functional/test_netdev_ethtool.py
+++ b/tests/functional/test_netdev_ethtool.py
@@ -8,8 +8,9 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
 from unittest import skip
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import wait_for_console_pattern
+
+from qemu_test import Asset, QemuSystemTest, wait_for_console_pattern
+
 
 class NetDevEthtool(QemuSystemTest):
 
diff --git a/tests/functional/test_or1k_sim.py b/tests/functional/test_or1k_sim.py
index f9f0b690a0a..780a99b3d7f 100755
--- a/tests/functional/test_or1k_sim.py
+++ b/tests/functional/test_or1k_sim.py
@@ -5,7 +5,7 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
+from qemu_test import Asset, LinuxKernelTest
 
 
 class OpenRISC1kSimTest(LinuxKernelTest):
diff --git a/tests/functional/test_pc_cpu_hotplug_props.py b/tests/functional/test_pc_cpu_hotplug_props.py
index 9d5a37cb170..ed151ccfd9b 100755
--- a/tests/functional/test_pc_cpu_hotplug_props.py
+++ b/tests/functional/test_pc_cpu_hotplug_props.py
@@ -23,6 +23,7 @@
 
 from qemu_test import QemuSystemTest
 
+
 class OmittedCPUProps(QemuSystemTest):
 
     def test_no_die_id(self):
diff --git a/tests/functional/test_ppc64_e500.py b/tests/functional/test_ppc64_e500.py
index f5fcad9f6b6..30a41e9ab86 100755
--- a/tests/functional/test_ppc64_e500.py
+++ b/tests/functional/test_ppc64_e500.py
@@ -4,8 +4,11 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
-from qemu_test import exec_command_and_wait_for_pattern
+from qemu_test import (
+    Asset,
+    LinuxKernelTest,
+    exec_command_and_wait_for_pattern,
+)
 
 
 class E500Test(LinuxKernelTest):
diff --git a/tests/functional/test_ppc64_hv.py b/tests/functional/test_ppc64_hv.py
index d87f440fa79..399b84a54c4 100755
--- a/tests/functional/test_ppc64_hv.py
+++ b/tests/functional/test_ppc64_hv.py
@@ -9,14 +9,20 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later.  See the COPYING file in the top-level directory.
 
+from datetime import datetime
 import os
 import subprocess
 
-from datetime import datetime
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import wait_for_console_pattern, exec_command
-from qemu_test import skipIfMissingCommands, skipBigDataTest
-from qemu_test import exec_command_and_wait_for_pattern
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    exec_command,
+    exec_command_and_wait_for_pattern,
+    skipBigDataTest,
+    skipIfMissingCommands,
+    wait_for_console_pattern,
+)
+
 
 # Alpine is a light weight distro that supports QEMU. These tests boot
 # that on the machine then run a QEMU guest inside it in KVM mode,
diff --git a/tests/functional/test_ppc64_mac99.py b/tests/functional/test_ppc64_mac99.py
index dfd9c01371d..b61349ea7bf 100755
--- a/tests/functional/test_ppc64_mac99.py
+++ b/tests/functional/test_ppc64_mac99.py
@@ -4,8 +4,12 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
-from qemu_test import exec_command_and_wait_for_pattern
+from qemu_test import (
+    Asset,
+    LinuxKernelTest,
+    exec_command_and_wait_for_pattern,
+)
+
 
 class mac99Test(LinuxKernelTest):
 
diff --git a/tests/functional/test_ppc64_powernv.py b/tests/functional/test_ppc64_powernv.py
index 685e2178ed7..ede777428bd 100755
--- a/tests/functional/test_ppc64_powernv.py
+++ b/tests/functional/test_ppc64_powernv.py
@@ -7,8 +7,8 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later.  See the COPYING file in the top-level directory.
 
-from qemu_test import LinuxKernelTest, Asset
-from qemu_test import wait_for_console_pattern
+from qemu_test import Asset, LinuxKernelTest, wait_for_console_pattern
+
 
 class powernvMachine(LinuxKernelTest):
 
diff --git a/tests/functional/test_ppc64_pseries.py b/tests/functional/test_ppc64_pseries.py
index 67057934e8d..5571a229b36 100755
--- a/tests/functional/test_ppc64_pseries.py
+++ b/tests/functional/test_ppc64_pseries.py
@@ -7,8 +7,8 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later.  See the COPYING file in the top-level directory.
 
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import wait_for_console_pattern
+from qemu_test import Asset, QemuSystemTest, wait_for_console_pattern
+
 
 class pseriesMachine(QemuSystemTest):
 
diff --git a/tests/functional/test_ppc64_reverse_debug.py b/tests/functional/test_ppc64_reverse_debug.py
index 5931adef5a9..0682a376765 100755
--- a/tests/functional/test_ppc64_reverse_debug.py
+++ b/tests/functional/test_ppc64_reverse_debug.py
@@ -12,7 +12,7 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later.  See the COPYING file in the top-level directory.
 
-from qemu_test import skipIfMissingImports, skipFlakyTest
+from qemu_test import skipFlakyTest, skipIfMissingImports
 from reverse_debugging import ReverseDebugging
 
 
diff --git a/tests/functional/test_ppc64_tuxrun.py b/tests/functional/test_ppc64_tuxrun.py
index e8f79c676e5..d0cd4154925 100755
--- a/tests/functional/test_ppc64_tuxrun.py
+++ b/tests/functional/test_ppc64_tuxrun.py
@@ -11,12 +11,13 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from subprocess import check_call, DEVNULL
+from subprocess import DEVNULL, check_call
 import tempfile
 
 from qemu_test import Asset
 from qemu_test.tuxruntest import TuxRunBaselineTest
 
+
 class TuxRunPPC64Test(TuxRunBaselineTest):
 
     def ppc64_common_tuxrun(self, kernel_asset, rootfs_asset, prefix):
diff --git a/tests/functional/test_ppc_40p.py b/tests/functional/test_ppc_40p.py
index 614972a7eb3..b572288d578 100755
--- a/tests/functional/test_ppc_40p.py
+++ b/tests/functional/test_ppc_40p.py
@@ -7,9 +7,13 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later. See the COPYING file in the top-level directory.
 
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import wait_for_console_pattern, skipUntrustedTest
-from qemu_test import exec_command_and_wait_for_pattern
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    exec_command_and_wait_for_pattern,
+    skipUntrustedTest,
+    wait_for_console_pattern,
+)
 
 
 class IbmPrep40pMachine(QemuSystemTest):
diff --git a/tests/functional/test_ppc_74xx.py b/tests/functional/test_ppc_74xx.py
index 5386016f261..b5429b0f90f 100755
--- a/tests/functional/test_ppc_74xx.py
+++ b/tests/functional/test_ppc_74xx.py
@@ -7,8 +7,8 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later.  See the COPYING file in the top-level directory.
 
-from qemu_test import QemuSystemTest
-from qemu_test import wait_for_console_pattern
+from qemu_test import QemuSystemTest, wait_for_console_pattern
+
 
 class ppc74xxCpu(QemuSystemTest):
 
diff --git a/tests/functional/test_ppc_amiga.py b/tests/functional/test_ppc_amiga.py
index 8600e2e9633..ad329812fe8 100755
--- a/tests/functional/test_ppc_amiga.py
+++ b/tests/functional/test_ppc_amiga.py
@@ -9,8 +9,7 @@
 
 import subprocess
 
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import wait_for_console_pattern
+from qemu_test import Asset, QemuSystemTest, wait_for_console_pattern
 
 
 class AmigaOneMachine(QemuSystemTest):
diff --git a/tests/functional/test_ppc_bamboo.py b/tests/functional/test_ppc_bamboo.py
index fddcc24d0da..53de5a42dc1 100755
--- a/tests/functional/test_ppc_bamboo.py
+++ b/tests/functional/test_ppc_bamboo.py
@@ -7,9 +7,12 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later.  See the COPYING file in the top-level directory.
 
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import wait_for_console_pattern
-from qemu_test import exec_command_and_wait_for_pattern
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    exec_command_and_wait_for_pattern,
+    wait_for_console_pattern,
+)
 
 
 class BambooMachine(QemuSystemTest):
diff --git a/tests/functional/test_ppc_mac.py b/tests/functional/test_ppc_mac.py
index 9e4bc1a52c7..708dbd6447e 100755
--- a/tests/functional/test_ppc_mac.py
+++ b/tests/functional/test_ppc_mac.py
@@ -4,7 +4,7 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
+from qemu_test import Asset, LinuxKernelTest
 
 
 class MacTest(LinuxKernelTest):
diff --git a/tests/functional/test_ppc_mpc8544ds.py b/tests/functional/test_ppc_mpc8544ds.py
index 0715410d7a2..7fd610eae30 100755
--- a/tests/functional/test_ppc_mpc8544ds.py
+++ b/tests/functional/test_ppc_mpc8544ds.py
@@ -7,8 +7,7 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later.  See the COPYING file in the top-level directory.
 
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import wait_for_console_pattern
+from qemu_test import Asset, QemuSystemTest, wait_for_console_pattern
 
 
 class Mpc8544dsMachine(QemuSystemTest):
diff --git a/tests/functional/test_ppc_sam460ex.py b/tests/functional/test_ppc_sam460ex.py
index 31cf9dd6de8..d7b87bcf22b 100644
--- a/tests/functional/test_ppc_sam460ex.py
+++ b/tests/functional/test_ppc_sam460ex.py
@@ -4,8 +4,11 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
-from qemu_test import exec_command_and_wait_for_pattern
+from qemu_test import (
+    Asset,
+    LinuxKernelTest,
+    exec_command_and_wait_for_pattern,
+)
 
 
 class sam460exTest(LinuxKernelTest):
diff --git a/tests/functional/test_ppc_tuxrun.py b/tests/functional/test_ppc_tuxrun.py
index 5458a7fb716..fe8db012e6b 100755
--- a/tests/functional/test_ppc_tuxrun.py
+++ b/tests/functional/test_ppc_tuxrun.py
@@ -14,6 +14,7 @@
 from qemu_test import Asset
 from qemu_test.tuxruntest import TuxRunBaselineTest
 
+
 class TuxRunPPC32Test(TuxRunBaselineTest):
 
     ASSET_PPC32_KERNEL = Asset(
diff --git a/tests/functional/test_ppc_virtex_ml507.py b/tests/functional/test_ppc_virtex_ml507.py
index 8fe43549b78..aef4369cca7 100755
--- a/tests/functional/test_ppc_virtex_ml507.py
+++ b/tests/functional/test_ppc_virtex_ml507.py
@@ -7,8 +7,7 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later.  See the COPYING file in the top-level directory.
 
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import wait_for_console_pattern
+from qemu_test import Asset, QemuSystemTest, wait_for_console_pattern
 
 
 class VirtexMl507Machine(QemuSystemTest):
diff --git a/tests/functional/test_riscv32_tuxrun.py b/tests/functional/test_riscv32_tuxrun.py
index 3c570208d03..043c8fb22ee 100755
--- a/tests/functional/test_riscv32_tuxrun.py
+++ b/tests/functional/test_riscv32_tuxrun.py
@@ -14,6 +14,7 @@
 from qemu_test import Asset
 from qemu_test.tuxruntest import TuxRunBaselineTest
 
+
 class TuxRunRiscV32Test(TuxRunBaselineTest):
 
     ASSET_RISCV32_KERNEL = Asset(
diff --git a/tests/functional/test_riscv64_tuxrun.py b/tests/functional/test_riscv64_tuxrun.py
index 0d8de36204a..1d4797ed21e 100755
--- a/tests/functional/test_riscv64_tuxrun.py
+++ b/tests/functional/test_riscv64_tuxrun.py
@@ -14,6 +14,7 @@
 from qemu_test import Asset
 from qemu_test.tuxruntest import TuxRunBaselineTest
 
+
 class TuxRunRiscV64Test(TuxRunBaselineTest):
 
     ASSET_RISCV64_KERNEL = Asset(
diff --git a/tests/functional/test_riscv_opensbi.py b/tests/functional/test_riscv_opensbi.py
index d077e40f427..bccc2b2fe16 100755
--- a/tests/functional/test_riscv_opensbi.py
+++ b/tests/functional/test_riscv_opensbi.py
@@ -7,8 +7,8 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later.  See the COPYING file in the top-level directory.
 
-from qemu_test import QemuSystemTest
-from qemu_test import wait_for_console_pattern
+from qemu_test import QemuSystemTest, wait_for_console_pattern
+
 
 class RiscvOpenSBI(QemuSystemTest):
 
diff --git a/tests/functional/test_rx_gdbsim.py b/tests/functional/test_rx_gdbsim.py
index 49245793e17..ee9a9902719 100755
--- a/tests/functional/test_rx_gdbsim.py
+++ b/tests/functional/test_rx_gdbsim.py
@@ -10,9 +10,13 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later.  See the COPYING file in the top-level directory.
 
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import exec_command_and_wait_for_pattern
-from qemu_test import wait_for_console_pattern, skipFlakyTest
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    exec_command_and_wait_for_pattern,
+    skipFlakyTest,
+    wait_for_console_pattern,
+)
 
 
 class RxGdbSimMachine(QemuSystemTest):
diff --git a/tests/functional/test_s390x_ccw_virtio.py b/tests/functional/test_s390x_ccw_virtio.py
index 453711aa0f5..f24ee8f4477 100755
--- a/tests/functional/test_s390x_ccw_virtio.py
+++ b/tests/functional/test_s390x_ccw_virtio.py
@@ -14,9 +14,12 @@
 import os
 import tempfile
 
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import exec_command_and_wait_for_pattern
-from qemu_test import wait_for_console_pattern
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    exec_command_and_wait_for_pattern,
+    wait_for_console_pattern,
+)
 
 
 class S390CCWVirtioMachine(QemuSystemTest):
diff --git a/tests/functional/test_s390x_topology.py b/tests/functional/test_s390x_topology.py
index 1b5dc651353..680036119fe 100755
--- a/tests/functional/test_s390x_topology.py
+++ b/tests/functional/test_s390x_topology.py
@@ -10,10 +10,13 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later.  See the COPYING file in the top-level directory.
 
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import exec_command
-from qemu_test import exec_command_and_wait_for_pattern
-from qemu_test import wait_for_console_pattern
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    exec_command,
+    exec_command_and_wait_for_pattern,
+    wait_for_console_pattern,
+)
 
 
 class S390CPUTopology(QemuSystemTest):
diff --git a/tests/functional/test_s390x_tuxrun.py b/tests/functional/test_s390x_tuxrun.py
index 8df3c6893b7..8c3bbedc702 100755
--- a/tests/functional/test_s390x_tuxrun.py
+++ b/tests/functional/test_s390x_tuxrun.py
@@ -14,6 +14,7 @@
 from qemu_test import Asset
 from qemu_test.tuxruntest import TuxRunBaselineTest
 
+
 class TuxRunS390xTest(TuxRunBaselineTest):
 
     ASSET_S390X_KERNEL = Asset(
diff --git a/tests/functional/test_sh4_r2d.py b/tests/functional/test_sh4_r2d.py
index 03a648374ce..d8d2abfe955 100755
--- a/tests/functional/test_sh4_r2d.py
+++ b/tests/functional/test_sh4_r2d.py
@@ -4,7 +4,7 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset, skipFlakyTest
+from qemu_test import Asset, LinuxKernelTest, skipFlakyTest
 
 
 class R2dTest(LinuxKernelTest):
diff --git a/tests/functional/test_sh4_tuxrun.py b/tests/functional/test_sh4_tuxrun.py
index 1748f8c7eff..f8006ffafbc 100755
--- a/tests/functional/test_sh4_tuxrun.py
+++ b/tests/functional/test_sh4_tuxrun.py
@@ -14,6 +14,7 @@
 from qemu_test import Asset, exec_command_and_wait_for_pattern
 from qemu_test.tuxruntest import TuxRunBaselineTest
 
+
 class TuxRunSh4Test(TuxRunBaselineTest):
 
     ASSET_SH4_KERNEL = Asset(
diff --git a/tests/functional/test_sh4eb_r2d.py b/tests/functional/test_sh4eb_r2d.py
index 473093bbe13..b7cc2f15b55 100755
--- a/tests/functional/test_sh4eb_r2d.py
+++ b/tests/functional/test_sh4eb_r2d.py
@@ -4,8 +4,11 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
-from qemu_test import exec_command_and_wait_for_pattern
+from qemu_test import (
+    Asset,
+    LinuxKernelTest,
+    exec_command_and_wait_for_pattern,
+)
 
 
 class R2dEBTest(LinuxKernelTest):
diff --git a/tests/functional/test_sparc64_sun4u.py b/tests/functional/test_sparc64_sun4u.py
index 27ac2896590..d18cc1e4a8f 100755
--- a/tests/functional/test_sparc64_sun4u.py
+++ b/tests/functional/test_sparc64_sun4u.py
@@ -10,8 +10,7 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later. See the COPYING file in the top-level directory.
 
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import wait_for_console_pattern
+from qemu_test import Asset, QemuSystemTest, wait_for_console_pattern
 
 
 class Sun4uMachine(QemuSystemTest):
diff --git a/tests/functional/test_sparc64_tuxrun.py b/tests/functional/test_sparc64_tuxrun.py
index 0d7b43dd74c..f5043eaebcb 100755
--- a/tests/functional/test_sparc64_tuxrun.py
+++ b/tests/functional/test_sparc64_tuxrun.py
@@ -14,6 +14,7 @@
 from qemu_test import Asset
 from qemu_test.tuxruntest import TuxRunBaselineTest
 
+
 class TuxRunSparc64Test(TuxRunBaselineTest):
 
     ASSET_SPARC64_KERNEL = Asset(
diff --git a/tests/functional/test_sparc_sun4m.py b/tests/functional/test_sparc_sun4m.py
index 7cd28ebdd1f..7707d93acd6 100755
--- a/tests/functional/test_sparc_sun4m.py
+++ b/tests/functional/test_sparc_sun4m.py
@@ -5,7 +5,7 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
+from qemu_test import Asset, LinuxKernelTest
 
 
 class Sun4mTest(LinuxKernelTest):
diff --git a/tests/functional/test_virtio_balloon.py b/tests/functional/test_virtio_balloon.py
index 5877b6c408c..ee7ee3f655e 100755
--- a/tests/functional/test_virtio_balloon.py
+++ b/tests/functional/test_virtio_balloon.py
@@ -7,9 +7,13 @@
 
 import time
 
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import wait_for_console_pattern
-from qemu_test import exec_command_and_wait_for_pattern
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    exec_command_and_wait_for_pattern,
+    wait_for_console_pattern,
+)
+
 
 UNSET_STATS_VALUE = 18446744073709551615
 
diff --git a/tests/functional/test_virtio_gpu.py b/tests/functional/test_virtio_gpu.py
index 81c9156d638..a725be8bbd0 100755
--- a/tests/functional/test_virtio_gpu.py
+++ b/tests/functional/test_virtio_gpu.py
@@ -6,16 +6,18 @@
 # later.  See the COPYING file in the top-level directory.
 
 
-from qemu_test import QemuSystemTest, Asset
-from qemu_test import wait_for_console_pattern
-from qemu_test import exec_command_and_wait_for_pattern
-from qemu_test import is_readable_executable_file
-
-
 import os
 import socket
 import subprocess
 
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    exec_command_and_wait_for_pattern,
+    is_readable_executable_file,
+    wait_for_console_pattern,
+)
+
 
 def pick_default_vug_bin(test):
     bld_dir_path = test.build_file("contrib", "vhost-user-gpu", "vhost-user-gpu")
diff --git a/tests/functional/test_virtio_version.py b/tests/functional/test_virtio_version.py
index a5ea73237f5..3b14534f862 100755
--- a/tests/functional/test_virtio_version.py
+++ b/tests/functional/test_virtio_version.py
@@ -13,6 +13,7 @@
 from qemu.machine import QEMUMachine
 from qemu_test import QemuSystemTest
 
+
 # Virtio Device IDs:
 VIRTIO_NET = 1
 VIRTIO_BLOCK = 2
diff --git a/tests/functional/test_x86_64_hotplug_blk.py b/tests/functional/test_x86_64_hotplug_blk.py
index 7ddbfefc210..9cbb47f0464 100755
--- a/tests/functional/test_x86_64_hotplug_blk.py
+++ b/tests/functional/test_x86_64_hotplug_blk.py
@@ -9,7 +9,11 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later.  See the COPYING file in the top-level directory.
 
-from qemu_test import LinuxKernelTest, Asset, exec_command_and_wait_for_pattern
+from qemu_test import (
+    Asset,
+    LinuxKernelTest,
+    exec_command_and_wait_for_pattern,
+)
 
 
 class HotPlugBlk(LinuxKernelTest):
diff --git a/tests/functional/test_x86_64_hotplug_cpu.py b/tests/functional/test_x86_64_hotplug_cpu.py
index 7b9200ac2e8..891a042c133 100755
--- a/tests/functional/test_x86_64_hotplug_cpu.py
+++ b/tests/functional/test_x86_64_hotplug_cpu.py
@@ -10,7 +10,11 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later.  See the COPYING file in the top-level directory.
 
-from qemu_test import LinuxKernelTest, Asset, exec_command_and_wait_for_pattern
+from qemu_test import (
+    Asset,
+    LinuxKernelTest,
+    exec_command_and_wait_for_pattern,
+)
 
 
 class HotPlugCPU(LinuxKernelTest):
diff --git a/tests/functional/test_x86_64_kvm_xen.py b/tests/functional/test_x86_64_kvm_xen.py
index a5d445023c9..7c559d1d557 100755
--- a/tests/functional/test_x86_64_kvm_xen.py
+++ b/tests/functional/test_x86_64_kvm_xen.py
@@ -12,9 +12,13 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
 from qemu.machine import machine
+from qemu_test import (
+    Asset,
+    QemuSystemTest,
+    exec_command_and_wait_for_pattern,
+    wait_for_console_pattern,
+)
 
-from qemu_test import QemuSystemTest, Asset, exec_command_and_wait_for_pattern
-from qemu_test import wait_for_console_pattern
 
 class KVMXenGuest(QemuSystemTest):
 
diff --git a/tests/functional/test_x86_64_replay.py b/tests/functional/test_x86_64_replay.py
index 27287d452dc..5380dc86540 100755
--- a/tests/functional/test_x86_64_replay.py
+++ b/tests/functional/test_x86_64_replay.py
@@ -5,9 +5,9 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from subprocess import check_call, DEVNULL
+from subprocess import DEVNULL, check_call
 
-from qemu_test import Asset, skipFlakyTest, get_qemu_img
+from qemu_test import Asset, get_qemu_img, skipFlakyTest
 from replay_kernel import ReplayKernelBase
 
 
diff --git a/tests/functional/test_x86_64_reverse_debug.py b/tests/functional/test_x86_64_reverse_debug.py
index d713e91e144..3309f62f44f 100755
--- a/tests/functional/test_x86_64_reverse_debug.py
+++ b/tests/functional/test_x86_64_reverse_debug.py
@@ -12,7 +12,7 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later.  See the COPYING file in the top-level directory.
 
-from qemu_test import skipIfMissingImports, skipFlakyTest
+from qemu_test import skipFlakyTest, skipIfMissingImports
 from reverse_debugging import ReverseDebugging
 
 
diff --git a/tests/functional/test_x86_64_tuxrun.py b/tests/functional/test_x86_64_tuxrun.py
index fcbc62b1b0f..c1283606009 100755
--- a/tests/functional/test_x86_64_tuxrun.py
+++ b/tests/functional/test_x86_64_tuxrun.py
@@ -14,6 +14,7 @@
 from qemu_test import Asset
 from qemu_test.tuxruntest import TuxRunBaselineTest
 
+
 class TuxRunX86Test(TuxRunBaselineTest):
 
     ASSET_X86_64_KERNEL = Asset(
diff --git a/tests/functional/test_x86_cpu_model_versions.py b/tests/functional/test_x86_cpu_model_versions.py
index bd18acd44fa..1281ea35630 100755
--- a/tests/functional/test_x86_cpu_model_versions.py
+++ b/tests/functional/test_x86_cpu_model_versions.py
@@ -25,6 +25,7 @@
 
 from qemu_test import QemuSystemTest
 
+
 class X86CPUModelAliases(QemuSystemTest):
     """
     Validation of PC CPU model versions and CPU model aliases
@@ -82,8 +83,8 @@ def test_4_0_alias_compatibility(self):
         # with older QEMU versions that didn't have the versioned CPU model
         self.vm.add_args('-S')
         self.vm.launch()
-        cpus = dict((m['name'], m) for m in
-                    self.vm.cmd('query-cpu-definitions'))
+        cpus = {m['name']: m for m in
+                    self.vm.cmd('query-cpu-definitions')}
 
         self.assertFalse(cpus['Cascadelake-Server']['static'],
                          'unversioned Cascadelake-Server CPU model must not be static')
@@ -113,8 +114,8 @@ def test_4_1_alias(self):
         self.vm.add_args('-S')
         self.vm.launch()
 
-        cpus = dict((m['name'], m) for m in
-                    self.vm.cmd('query-cpu-definitions'))
+        cpus = {m['name']: m for m in
+                    self.vm.cmd('query-cpu-definitions')}
 
         self.assertFalse(cpus['Cascadelake-Server']['static'],
                          'unversioned Cascadelake-Server CPU model must not be static')
@@ -219,8 +220,8 @@ def test_none_alias(self):
         self.vm.add_args('-S')
         self.vm.launch()
 
-        cpus = dict((m['name'], m) for m in
-                    self.vm.cmd('query-cpu-definitions'))
+        cpus = {m['name']: m for m in
+                    self.vm.cmd('query-cpu-definitions')}
 
         self.assertFalse(cpus['Cascadelake-Server']['static'],
                          'unversioned Cascadelake-Server CPU model must not be static')
diff --git a/tests/functional/test_xtensa_lx60.py b/tests/functional/test_xtensa_lx60.py
index 147c9208991..2b4af35334c 100755
--- a/tests/functional/test_xtensa_lx60.py
+++ b/tests/functional/test_xtensa_lx60.py
@@ -5,7 +5,7 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-from qemu_test import LinuxKernelTest, Asset
+from qemu_test import Asset, LinuxKernelTest
 
 
 class XTensaLX60Test(LinuxKernelTest):
diff --git a/tests/guest-debug/run-test.py b/tests/guest-debug/run-test.py
index 75e9c92e036..4d4152a83c4 100755
--- a/tests/guest-debug/run-test.py
+++ b/tests/guest-debug/run-test.py
@@ -12,12 +12,13 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
 import argparse
-import subprocess
-import shutil
-import shlex
 import os
-from time import sleep
+import shlex
+import shutil
+import subprocess
 from tempfile import TemporaryDirectory
+from time import sleep
+
 
 def get_args():
     parser = argparse.ArgumentParser(description="A gdbstub test runner")
diff --git a/tests/guest-debug/test_gdbstub.py b/tests/guest-debug/test_gdbstub.py
index 4f08089e6a9..8126b57ba74 100644
--- a/tests/guest-debug/test_gdbstub.py
+++ b/tests/guest-debug/test_gdbstub.py
@@ -1,13 +1,14 @@
 """Helper functions for gdbstub testing
 
 """
-from __future__ import print_function
 import argparse
-import gdb
 import os
 import sys
 import traceback
 
+import gdb
+
+
 fail_count = 0
 
 
@@ -24,9 +25,9 @@ def exit(self, status=None, message=""):
 def report(cond, msg):
     """Report success/fail of a test"""
     if cond:
-        print("PASS: {}".format(msg))
+        print(f"PASS: {msg}")
     else:
-        print("FAIL: {}".format(msg))
+        print(f"FAIL: {msg}")
         global fail_count
         fail_count += 1
 
@@ -38,10 +39,10 @@ def main(test, expected_arch=None):
     try:
         inferior = gdb.selected_inferior()
         arch = inferior.architecture()
-        print("ATTACHED: {}".format(arch.name()))
+        print(f"ATTACHED: {arch.name()}")
         if expected_arch is not None:
             report(arch.name() == expected_arch,
-                   "connected to {}".format(expected_arch))
+                   f"connected to {expected_arch}")
     except (gdb.error, AttributeError):
         print("SKIP: not connected")
         gdb_exit(0)
@@ -67,5 +68,5 @@ def main(test, expected_arch=None):
     except gdb.error:
         pass
 
-    print("All tests complete: {} failures".format(fail_count))
+    print(f"All tests complete: {fail_count} failures")
     gdb_exit(fail_count)
diff --git a/tests/image-fuzzer/qcow2/fuzz.py b/tests/image-fuzzer/qcow2/fuzz.py
index c58bf110054..39d83f2d304 100644
--- a/tests/image-fuzzer/qcow2/fuzz.py
+++ b/tests/image-fuzzer/qcow2/fuzz.py
@@ -16,8 +16,9 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import random
 from functools import reduce
+import random
+
 
 UINT8 = 0xff
 UINT16 = 0xffff
diff --git a/tests/image-fuzzer/qcow2/layout.py b/tests/image-fuzzer/qcow2/layout.py
index 57ebe86e9a0..c6bcfdd207d 100644
--- a/tests/image-fuzzer/qcow2/layout.py
+++ b/tests/image-fuzzer/qcow2/layout.py
@@ -16,12 +16,14 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
+from itertools import chain
+from math import ceil
+from os import urandom
 import random
 import struct
+
 from . import fuzz
-from math import ceil
-from os import urandom
-from itertools import chain
+
 
 MAX_IMAGE_SIZE = 10 * (1 << 20)
 # Standard sizes
@@ -29,7 +31,7 @@
 UINT64_S = 8
 
 
-class Field(object):
+class Field:
 
     """Atomic image element (field).
 
@@ -56,7 +58,7 @@ def __repr__(self):
             (self.fmt, self.offset, self.value, self.name)
 
 
-class FieldsList(object):
+class FieldsList:
 
     """List of fields.
 
@@ -80,7 +82,7 @@ def __len__(self):
         return len(self.data)
 
 
-class Image(object):
+class Image:
 
     """ Qcow2 image object.
 
@@ -338,14 +340,14 @@ def create_refcount_structures(self):
         def allocate_rfc_blocks(data, size):
             """Return indices of clusters allocated for refcount blocks."""
             cluster_ids = set()
-            diff = block_ids = set([x // size for x in data])
+            diff = block_ids = {x // size for x in data}
             while len(diff) != 0:
                 # Allocate all yet not allocated clusters
                 new = self._get_available_clusters(data | cluster_ids,
                                                    len(diff))
                 # Indices of new refcount blocks necessary to cover clusters
                 # in 'new'
-                diff = set([x // size for x in new]) - block_ids
+                diff = {x // size for x in new} - block_ids
                 cluster_ids |= new
                 block_ids |= diff
             return cluster_ids, block_ids
@@ -372,7 +374,7 @@ def allocate_rfc_table(data, init_blocks, block_size):
                                                  table_size + 1))
             # New refcount blocks necessary for clusters occupied by the
             # refcount table
-            diff = set([c // block_size for c in table_clusters]) - blocks
+            diff = {c // block_size for c in table_clusters} - blocks
             blocks |= diff
             while len(diff) != 0:
                 # Allocate clusters for new refcount blocks
@@ -381,7 +383,7 @@ def allocate_rfc_table(data, init_blocks, block_size):
                                                    len(diff))
                 # Indices of new refcount blocks necessary to cover
                 # clusters in 'new'
-                diff = set([x // block_size for x in new]) - blocks
+                diff = {x // block_size for x in new} - blocks
                 clusters |= new
                 blocks |= diff
                 # Check if the refcount table needs one more cluster
@@ -420,12 +422,12 @@ def create_block_entry(block_cluster, block_size, cluster):
             # All metadata for an empty guest image needs 4 clusters:
             # header, rfc table, rfc block, L1 table.
             # Header takes cluster #0, other clusters ##1-3 can be used
-            block_clusters = set([random.choice(list(set(range(1, 4)) -
-                                                     meta_data))])
-            block_ids = set([0])
-            table_clusters = set([random.choice(list(set(range(1, 4)) -
+            block_clusters = {random.choice(list(set(range(1, 4)) -
+                                                     meta_data))}
+            block_ids = {0}
+            table_clusters = {random.choice(list(set(range(1, 4)) -
                                                      meta_data -
-                                                     block_clusters))])
+                                                     block_clusters))}
         else:
             block_clusters, block_ids = \
                                 allocate_rfc_blocks(self.data_clusters |
diff --git a/tests/image-fuzzer/runner.py b/tests/image-fuzzer/runner.py
index 2fc010fd9d7..e198623955e 100755
--- a/tests/image-fuzzer/runner.py
+++ b/tests/image-fuzzer/runner.py
@@ -18,17 +18,18 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import sys
+import getopt
+import io
+from itertools import count
 import os
-import signal
-import subprocess
 import random
+import resource
 import shutil
-from itertools import count
+import signal
+import subprocess
+import sys
 import time
-import getopt
-import io
-import resource
+
 
 try:
     import json
@@ -67,7 +68,6 @@ def run_app(fd, q_args):
 
     class Alarm(Exception):
         """Exception for signal.alarm events."""
-        pass
 
     def handler(*args):
         """Notify that an alarm event occurred."""
@@ -98,10 +98,9 @@ def handler(*args):
 
 class TestException(Exception):
     """Exception for errors risen by TestEnv objects."""
-    pass
 
 
-class TestEnv(object):
+class TestEnv:
 
     """Test object.
 
diff --git a/tests/lcitool/refresh b/tests/lcitool/refresh
index d3488b2679e..e0e127ee2ff 100755
--- a/tests/lcitool/refresh
+++ b/tests/lcitool/refresh
@@ -12,10 +12,10 @@
 # or (at your option) any later version. See the COPYING file in
 # the top-level directory.
 
-import sys
-import subprocess
-
 from pathlib import Path
+import subprocess
+import sys
+
 
 if len(sys.argv) != 1:
     print("syntax: %s" % sys.argv[0], file=sys.stderr)
diff --git a/tests/migration-stress/guestperf-batch.py b/tests/migration-stress/guestperf-batch.py
index 9485eefe496..5405df35c08 100755
--- a/tests/migration-stress/guestperf-batch.py
+++ b/tests/migration-stress/guestperf-batch.py
@@ -22,5 +22,6 @@
 
 from guestperf.shell import BatchShell
 
+
 shell = BatchShell()
 sys.exit(shell.run(sys.argv[1:]))
diff --git a/tests/migration-stress/guestperf-plot.py b/tests/migration-stress/guestperf-plot.py
index 32977b4bf69..6d4c1335dbc 100755
--- a/tests/migration-stress/guestperf-plot.py
+++ b/tests/migration-stress/guestperf-plot.py
@@ -22,5 +22,6 @@
 
 from guestperf.shell import PlotShell
 
+
 shell = PlotShell()
 sys.exit(shell.run(sys.argv[1:]))
diff --git a/tests/migration-stress/guestperf.py b/tests/migration-stress/guestperf.py
index 07182f211e5..cf25d93f618 100755
--- a/tests/migration-stress/guestperf.py
+++ b/tests/migration-stress/guestperf.py
@@ -23,5 +23,6 @@
 
 from guestperf.shell import Shell
 
+
 shell = Shell()
 sys.exit(shell.run(sys.argv[1:]))
diff --git a/tests/migration-stress/guestperf/comparison.py b/tests/migration-stress/guestperf/comparison.py
index dee3ac25e46..4b1167c77da 100644
--- a/tests/migration-stress/guestperf/comparison.py
+++ b/tests/migration-stress/guestperf/comparison.py
@@ -19,7 +19,8 @@
 
 from guestperf.scenario import Scenario
 
-class Comparison(object):
+
+class Comparison:
     def __init__(self, name, scenarios):
         self._name = name
         self._scenarios = scenarios
diff --git a/tests/migration-stress/guestperf/engine.py b/tests/migration-stress/guestperf/engine.py
index d8462db7653..781eae6f98f 100644
--- a/tests/migration-stress/guestperf/engine.py
+++ b/tests/migration-stress/guestperf/engine.py
@@ -27,14 +27,16 @@
 from guestperf.report import Report, ReportResult
 from guestperf.timings import TimingRecord, Timings
 
+
 sys.path.append(os.path.join(os.path.dirname(__file__),
                              '..', '..', '..', 'python'))
 from qemu.machine import QEMUMachine
 
+
 # multifd supported compression algorithms
 MULTIFD_CMP_ALGS = ("zlib", "zstd", "qpl", "uadk")
 
-class Engine(object):
+class Engine:
 
     def __init__(self, binary, dst_host, kernel, initrd, transport="tcp",
                  sleep=15, verbose=False, debug=False):
@@ -58,7 +60,7 @@ def _vcpu_timing(self, pid, tid_list):
         jiffies_per_sec = os.sysconf(os.sysconf_names['SC_CLK_TCK'])
         for tid in tid_list:
             statfile = "/proc/%d/task/%d/stat" % (pid, tid)
-            with open(statfile, "r") as fh:
+            with open(statfile) as fh:
                 stat = fh.readline()
                 fields = stat.split(" ")
                 stime = int(fields[13])
@@ -71,7 +73,7 @@ def _cpu_timing(self, pid):
 
         jiffies_per_sec = os.sysconf(os.sysconf_names['SC_CLK_TCK'])
         statfile = "/proc/%d/stat" % pid
-        with open(statfile, "r") as fh:
+        with open(statfile) as fh:
             stat = fh.readline()
             fields = stat.split(" ")
             stime = int(fields[13])
diff --git a/tests/migration-stress/guestperf/hardware.py b/tests/migration-stress/guestperf/hardware.py
index f779cc050be..583be7a1f00 100644
--- a/tests/migration-stress/guestperf/hardware.py
+++ b/tests/migration-stress/guestperf/hardware.py
@@ -18,7 +18,7 @@
 #
 
 
-class Hardware(object):
+class Hardware:
     def __init__(self, cpus=1, mem=1,
                  src_cpu_bind=None, src_mem_bind=None,
                  dst_cpu_bind=None, dst_mem_bind=None,
diff --git a/tests/migration-stress/guestperf/plot.py b/tests/migration-stress/guestperf/plot.py
index 30b3f668d06..7b0b9fe4f31 100644
--- a/tests/migration-stress/guestperf/plot.py
+++ b/tests/migration-stress/guestperf/plot.py
@@ -20,7 +20,7 @@
 import sys
 
 
-class Plot(object):
+class Plot:
 
     # Generated using
     # http://tools.medialab.sciences-po.fr/iwanthue/
@@ -358,8 +358,8 @@ def _generate_annotations(self, report):
         return annotations.values()
 
     def _generate_chart(self):
+        from plotly import graph_objs as go
         from plotly.offline import plot
-        from plotly import graph_objs as go
 
         graphs = []
         yaxismax = 0
diff --git a/tests/migration-stress/guestperf/progress.py b/tests/migration-stress/guestperf/progress.py
index d4905842172..9d1396bc854 100644
--- a/tests/migration-stress/guestperf/progress.py
+++ b/tests/migration-stress/guestperf/progress.py
@@ -18,7 +18,7 @@
 #
 
 
-class ProgressStats(object):
+class ProgressStats:
 
     def __init__(self,
                  transferred_bytes,
@@ -71,7 +71,7 @@ def deserialize(cls, data):
             data["iterations"])
 
 
-class Progress(object):
+class Progress:
 
     def __init__(self,
                  status,
diff --git a/tests/migration-stress/guestperf/report.py b/tests/migration-stress/guestperf/report.py
index e135e01be6e..bb5949e4f29 100644
--- a/tests/migration-stress/guestperf/report.py
+++ b/tests/migration-stress/guestperf/report.py
@@ -20,11 +20,12 @@
 import json
 
 from guestperf.hardware import Hardware
-from guestperf.scenario import Scenario
 from guestperf.progress import Progress
+from guestperf.scenario import Scenario
 from guestperf.timings import Timings
 
-class ReportResult(object):
+
+class ReportResult:
 
     def __init__(self, success=False):
         self._success = success
@@ -40,7 +41,7 @@ def deserialize(cls, data):
             data["success"])
 
 
-class Report(object):
+class Report:
 
     def __init__(self,
                  hardware,
@@ -114,5 +115,5 @@ def from_json(cls, data):
 
     @classmethod
     def from_json_file(cls, filename):
-        with open(filename, "r") as fh:
+        with open(filename) as fh:
             return cls.deserialize(json.load(fh))
diff --git a/tests/migration-stress/guestperf/scenario.py b/tests/migration-stress/guestperf/scenario.py
index 4be7fafebf9..9451166061e 100644
--- a/tests/migration-stress/guestperf/scenario.py
+++ b/tests/migration-stress/guestperf/scenario.py
@@ -18,7 +18,7 @@
 #
 
 
-class Scenario(object):
+class Scenario:
 
     def __init__(self, name,
                  downtime=500,
diff --git a/tests/migration-stress/guestperf/shell.py b/tests/migration-stress/guestperf/shell.py
index 63bbe3226c6..373d3277119 100644
--- a/tests/migration-stress/guestperf/shell.py
+++ b/tests/migration-stress/guestperf/shell.py
@@ -20,21 +20,21 @@
 
 import argparse
 import fnmatch
+import logging
 import os
 import os.path
 import platform
 import sys
-import logging
 
-from guestperf.hardware import Hardware
-from guestperf.engine import Engine
-from guestperf.scenario import Scenario
 from guestperf.comparison import COMPARISONS
+from guestperf.engine import Engine
+from guestperf.hardware import Hardware
 from guestperf.plot import Plot
 from guestperf.report import Report
+from guestperf.scenario import Scenario
 
 
-class BaseShell(object):
+class BaseShell:
 
     def __init__(self):
         parser = argparse.ArgumentParser(description="Migration Test Tool")
@@ -100,7 +100,7 @@ def split_map(value):
 class Shell(BaseShell):
 
     def __init__(self):
-        super(Shell, self).__init__()
+        super().__init__()
 
         parser = self._parser
 
@@ -205,7 +205,7 @@ def run(self, argv):
 class BatchShell(BaseShell):
 
     def __init__(self):
-        super(BatchShell, self).__init__()
+        super().__init__()
 
         parser = self._parser
 
@@ -248,10 +248,10 @@ def run(self, argv):
                 raise
 
 
-class PlotShell(object):
+class PlotShell:
 
     def __init__(self):
-        super(PlotShell, self).__init__()
+        super().__init__()
 
         self._parser = argparse.ArgumentParser(description="Migration Test Tool")
 
diff --git a/tests/migration-stress/guestperf/timings.py b/tests/migration-stress/guestperf/timings.py
index 2374010c6c9..f2c478e635a 100644
--- a/tests/migration-stress/guestperf/timings.py
+++ b/tests/migration-stress/guestperf/timings.py
@@ -18,7 +18,7 @@
 #
 
 
-class TimingRecord(object):
+class TimingRecord:
 
     def __init__(self, tid, timestamp, value):
 
@@ -41,7 +41,7 @@ def deserialize(cls, data):
             data["value"])
 
 
-class Timings(object):
+class Timings:
 
     def __init__(self, records):
 
diff --git a/tests/qapi-schema/test-qapi.py b/tests/qapi-schema/test-qapi.py
index 4be930228cc..6a6a4242c1e 100755
--- a/tests/qapi-schema/test-qapi.py
+++ b/tests/qapi-schema/test-qapi.py
@@ -14,9 +14,9 @@
 
 import argparse
 import difflib
+from io import StringIO
 import os
 import sys
-from io import StringIO
 
 from qapi.error import QAPIError
 from qapi.schema import QAPISchema, QAPISchemaVisitor
diff --git a/tests/qemu-iotests/030 b/tests/qemu-iotests/030
index 0e6a39d103c..1ab4a5d6d6b 100755
--- a/tests/qemu-iotests/030
+++ b/tests/qemu-iotests/030
@@ -19,12 +19,14 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import time
 import os
-import iotests
+import time
 import unittest
+
+import iotests
 from iotests import qemu_img, qemu_io
 
+
 backing_img = os.path.join(iotests.test_dir, 'backing.img')
 mid_img = os.path.join(iotests.test_dir, 'mid.img')
 test_img = os.path.join(iotests.test_dir, 'test.img')
diff --git a/tests/qemu-iotests/040 b/tests/qemu-iotests/040
index 5c18e413ec9..a0495d4a2f9 100755
--- a/tests/qemu-iotests/040
+++ b/tests/qemu-iotests/040
@@ -22,12 +22,12 @@
 # Test for live block commit
 # Derived from Image Streaming Test 030
 
-import time
+import errno
 import os
+
 import iotests
 from iotests import qemu_img, qemu_io
-import struct
-import errno
+
 
 backing_img = os.path.join(iotests.test_dir, 'backing.img')
 mid_img = os.path.join(iotests.test_dir, 'mid.img')
diff --git a/tests/qemu-iotests/041 b/tests/qemu-iotests/041
index 8452845f448..4614bfb2730 100755
--- a/tests/qemu-iotests/041
+++ b/tests/qemu-iotests/041
@@ -19,13 +19,14 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import time
 import os
 import re
-import json
+import time
+
 import iotests
 from iotests import qemu_img, qemu_img_map, qemu_io
 
+
 backing_img = os.path.join(iotests.test_dir, 'backing.img')
 target_backing_img = os.path.join(iotests.test_dir, 'target-backing.img')
 test_img = os.path.join(iotests.test_dir, 'test.img')
@@ -270,7 +271,7 @@ class TestSingleBlockdev(TestSingleDrive):
         self.assertEqual(result, 'Source and target image have different sizes')
 
     # qed does not support shrinking
-    @iotests.skip_for_formats(('qed'))
+    @iotests.skip_for_formats('qed')
     def test_small_target(self):
         self.do_test_target_size(self.image_len // 2)
 
diff --git a/tests/qemu-iotests/044 b/tests/qemu-iotests/044
index a5ee9a7ded3..60c522f37e3 100755
--- a/tests/qemu-iotests/044
+++ b/tests/qemu-iotests/044
@@ -19,15 +19,15 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import time
 import os
+import struct
+
 import qcow2
 from qcow2 import QcowHeader
+
 import iotests
 from iotests import qemu_img, qemu_img_log, qemu_io
-import struct
-import subprocess
-import sys
+
 
 test_img = os.path.join(iotests.test_dir, 'test.img')
 
@@ -103,17 +103,14 @@ class TestRefcountTableGrowth(iotests.QMPTestCase):
     def setUp(self):
         qemu_img('create', '-f', iotests.imgfmt, '-o', 'cluster_size=512', test_img, '16G')
         self.preallocate(test_img)
-        pass
 
 
     def tearDown(self):
         os.remove(test_img)
-        pass
 
     def test_grow_refcount_table(self):
         qemu_io('-c', 'write 3800M 1M', test_img)
         qemu_img_log('check' , test_img)
-        pass
 
 if __name__ == '__main__':
     iotests.activate_logging()
diff --git a/tests/qemu-iotests/045 b/tests/qemu-iotests/045
index a341f21cd70..9cbf3fab54b 100755
--- a/tests/qemu-iotests/045
+++ b/tests/qemu-iotests/045
@@ -20,9 +20,11 @@
 #
 
 import os
+
 import iotests
 from iotests import qemu_img
 
+
 image0 = os.path.join(iotests.test_dir, 'image0')
 image1 = os.path.join(iotests.test_dir, 'image1')
 image2 = os.path.join(iotests.test_dir, 'image2')
@@ -38,11 +40,11 @@ class TestFdSets(iotests.QMPTestCase):
         qemu_img('create', '-f', iotests.imgfmt, image2, '128K')
         qemu_img('create', '-f', iotests.imgfmt, image3, '128K')
         qemu_img('create', '-f', iotests.imgfmt, image4, '128K')
-        self.file0 = open(image0, 'r')
+        self.file0 = open(image0)
         self.file1 = open(image1, 'w+')
-        self.file2 = open(image2, 'r')
-        self.file3 = open(image3, 'r')
-        self.file4 = open(image4, 'r')
+        self.file2 = open(image2)
+        self.file3 = open(image3)
+        self.file4 = open(image4)
         self.vm.add_fd(self.file0.fileno(), 1, 'image0:r')
         self.vm.add_fd(self.file1.fileno(), 1, 'image1:w+')
         self.vm.add_fd(self.file2.fileno(), 0, 'image2:r')
diff --git a/tests/qemu-iotests/055 b/tests/qemu-iotests/055
index d8372b55988..602070848ac 100755
--- a/tests/qemu-iotests/055
+++ b/tests/qemu-iotests/055
@@ -21,11 +21,13 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import time
 import os
+import time
+
 import iotests
 from iotests import qemu_img, qemu_io
 
+
 test_img = os.path.join(iotests.test_dir, 'test.img')
 target_img = os.path.join(iotests.test_dir, 'target.img')
 blockdev_target_img = os.path.join(iotests.test_dir, 'blockdev-target.img')
diff --git a/tests/qemu-iotests/056 b/tests/qemu-iotests/056
index 808ea6b48ab..937d51b0561 100755
--- a/tests/qemu-iotests/056
+++ b/tests/qemu-iotests/056
@@ -21,10 +21,12 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import time
 import os
+import time
+
 import iotests
-from iotests import qemu_img, qemu_io, create_image
+from iotests import create_image, qemu_img, qemu_io
+
 
 backing_img = os.path.join(iotests.test_dir, 'backing.img')
 test_img = os.path.join(iotests.test_dir, 'test.img')
diff --git a/tests/qemu-iotests/057 b/tests/qemu-iotests/057
index b0d431999e7..84d8e034941 100755
--- a/tests/qemu-iotests/057
+++ b/tests/qemu-iotests/057
@@ -21,11 +21,12 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import time
 import os
+
 import iotests
 from iotests import qemu_img, qemu_io
 
+
 test_drv_base_name = 'drive'
 
 class ImageSnapshotTestCase(iotests.QMPTestCase):
@@ -33,7 +34,7 @@ class ImageSnapshotTestCase(iotests.QMPTestCase):
 
     def __init__(self, *args):
         self.expect = []
-        super(ImageSnapshotTestCase, self).__init__(*args)
+        super().__init__(*args)
 
     def _setUp(self, test_img_base_name, image_num):
         self.vm = iotests.VM()
diff --git a/tests/qemu-iotests/065 b/tests/qemu-iotests/065
index b76701c71e8..60e7f198ff1 100755
--- a/tests/qemu-iotests/065
+++ b/tests/qemu-iotests/065
@@ -22,10 +22,14 @@
 
 import os
 import re
-import json
+
 import iotests
-from iotests import qemu_img, qemu_img_info, supports_qcow2_zstd_compression
-import unittest
+from iotests import (
+    qemu_img,
+    qemu_img_info,
+    supports_qcow2_zstd_compression,
+)
+
 
 test_img = os.path.join(iotests.test_dir, 'test.img')
 
diff --git a/tests/qemu-iotests/093 b/tests/qemu-iotests/093
index 4f9e224e8a8..25604c814b1 100755
--- a/tests/qemu-iotests/093
+++ b/tests/qemu-iotests/093
@@ -22,6 +22,7 @@
 
 import iotests
 
+
 nsec_per_sec = 1000000000
 
 class ThrottleTestCase(iotests.QMPTestCase):
@@ -154,7 +155,7 @@ class ThrottleTestCase(iotests.QMPTestCase):
         for ndrives in range(1, self.max_drives + 1):
             # Pick each out of all possible params and test
             for tk in params:
-                limits = dict([(k, 0) for k in params])
+                limits = {k: 0 for k in params}
                 limits[tk] = params[tk] * ndrives
                 self.configure_throttle(ndrives, limits)
                 self.do_test_throttle(ndrives, 5, limits)
@@ -172,7 +173,7 @@ class ThrottleTestCase(iotests.QMPTestCase):
         for drive in range(0, self.max_drives):
             # Pick each out of all possible params and test
             for tk in params:
-                limits = dict([(k, 0) for k in params])
+                limits = {k: 0 for k in params}
                 limits[tk] = params[tk] * self.max_drives
                 self.configure_throttle(self.max_drives, limits)
                 self.do_test_throttle(1, 5, limits, drive)
@@ -193,7 +194,7 @@ class ThrottleTestCase(iotests.QMPTestCase):
             burst_length = 4
 
             # Configure the throttling settings
-            settings = dict([(k, 0) for k in params])
+            settings = {k: 0 for k in params}
             settings[tk] = rate
             settings['%s_max' % tk] = burst_rate
             settings['%s_max_length' % tk] = burst_length
@@ -204,7 +205,7 @@ class ThrottleTestCase(iotests.QMPTestCase):
             self.vm.qtest("clock_step %d" % wait_ns)
 
             # Test I/O at the max burst rate
-            limits = dict([(k, 0) for k in params])
+            limits = {k: 0 for k in params}
             limits[tk] = burst_rate
             self.do_test_throttle(ndrives, burst_length, limits)
 
diff --git a/tests/qemu-iotests/096 b/tests/qemu-iotests/096
index b5d7636bdc3..56e7e17b777 100755
--- a/tests/qemu-iotests/096
+++ b/tests/qemu-iotests/096
@@ -20,9 +20,11 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import iotests
 import os
 
+import iotests
+
+
 class TestLiveSnapshot(iotests.QMPTestCase):
     base_img = os.path.join(iotests.test_dir, 'base.img')
     target_img = os.path.join(iotests.test_dir, 'target.img')
diff --git a/tests/qemu-iotests/118 b/tests/qemu-iotests/118
index 6a4210c2199..70093761649 100755
--- a/tests/qemu-iotests/118
+++ b/tests/qemu-iotests/118
@@ -20,11 +20,11 @@
 #
 
 import os
-import stat
-import time
+
 import iotests
 from iotests import qemu_img
 
+
 old_img = os.path.join(iotests.test_dir, 'test0.img')
 new_img = os.path.join(iotests.test_dir, 'test1.img')
 
diff --git a/tests/qemu-iotests/124 b/tests/qemu-iotests/124
index b2f4328e345..807201a0c5e 100755
--- a/tests/qemu-iotests/124
+++ b/tests/qemu-iotests/124
@@ -22,9 +22,11 @@
 #
 
 import os
+
+from qemu.qmp.qmp_client import ExecuteError
+
 import iotests
 from iotests import try_remove
-from qemu.qmp.qmp_client import ExecuteError
 
 
 def io_write_patterns(img, patterns):
@@ -35,7 +37,7 @@ def io_write_patterns(img, patterns):
 def transaction_action(action, **kwargs):
     return {
         'type': action,
-        'data': dict((k.replace('_', '-'), v) for k, v in kwargs.items())
+        'data': {k.replace('_', '-'): v for k, v in kwargs.items()}
     }
 
 
@@ -89,7 +91,7 @@ class Bitmap:
 
 class TestIncrementalBackupBase(iotests.QMPTestCase):
     def __init__(self, *args):
-        super(TestIncrementalBackupBase, self).__init__(*args)
+        super().__init__(*args)
         self.bitmaps = list()
         self.files = list()
         self.drives = list()
diff --git a/tests/qemu-iotests/129 b/tests/qemu-iotests/129
index 97773cd96da..483db4c3f77 100755
--- a/tests/qemu-iotests/129
+++ b/tests/qemu-iotests/129
@@ -20,8 +20,10 @@
 #
 
 import os
+
 import iotests
 
+
 class TestStopWithBlockJob(iotests.QMPTestCase):
     test_img = os.path.join(iotests.test_dir, 'test.img')
     target_img = os.path.join(iotests.test_dir, 'target.img')
diff --git a/tests/qemu-iotests/132 b/tests/qemu-iotests/132
index 12a64b3d95a..48bda80db8b 100755
--- a/tests/qemu-iotests/132
+++ b/tests/qemu-iotests/132
@@ -19,11 +19,12 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import time
 import os
+
 import iotests
 from iotests import qemu_img, qemu_io
 
+
 test_img = os.path.join(iotests.test_dir, 'test.img')
 target_img = os.path.join(iotests.test_dir, 'target.img')
 
diff --git a/tests/qemu-iotests/136 b/tests/qemu-iotests/136
index 8fce88bd677..af8aa91cc41 100755
--- a/tests/qemu-iotests/136
+++ b/tests/qemu-iotests/136
@@ -20,9 +20,11 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import iotests
 import os
 
+import iotests
+
+
 interval_length = 10
 nsec_per_sec = 1000000000
 op_latency = nsec_per_sec // 1000 # See qtest_latency_ns in accounting.c
diff --git a/tests/qemu-iotests/139 b/tests/qemu-iotests/139
index ebb4cd62b6f..e43066a7f34 100755
--- a/tests/qemu-iotests/139
+++ b/tests/qemu-iotests/139
@@ -21,8 +21,9 @@
 #
 
 import os
+
 import iotests
-import time
+
 
 base_img = os.path.join(iotests.test_dir, 'base.img')
 new_img = os.path.join(iotests.test_dir, 'new.img')
diff --git a/tests/qemu-iotests/141 b/tests/qemu-iotests/141
index a7d3985a02e..9c82a819cb9 100755
--- a/tests/qemu-iotests/141
+++ b/tests/qemu-iotests/141
@@ -24,6 +24,7 @@
 
 import iotests
 
+
 # Common filters to mask values that vary in the test output
 QMP_FILTERS = [iotests.filter_qmp_testfiles, \
                iotests.filter_qmp_imgfmt]
diff --git a/tests/qemu-iotests/147 b/tests/qemu-iotests/147
index 6d6f077a14d..2c5d62889dd 100755
--- a/tests/qemu-iotests/147
+++ b/tests/qemu-iotests/147
@@ -22,10 +22,17 @@
 import os
 import random
 import socket
-import stat
-import time
+
 import iotests
-from iotests import cachemode, aiomode, imgfmt, qemu_img, qemu_nbd, qemu_nbd_early_pipe
+from iotests import (
+    aiomode,
+    cachemode,
+    imgfmt,
+    qemu_img,
+    qemu_nbd,
+    qemu_nbd_early_pipe,
+)
+
 
 NBD_PORT_START      = 32768
 NBD_PORT_END        = NBD_PORT_START + 1024
diff --git a/tests/qemu-iotests/148 b/tests/qemu-iotests/148
index 7ccbde4633c..e3b7c88e2ae 100755
--- a/tests/qemu-iotests/148
+++ b/tests/qemu-iotests/148
@@ -21,8 +21,10 @@
 #
 
 import os
+
 import iotests
 
+
 imgs = (os.path.join(iotests.test_dir, 'quorum0.img'),
         os.path.join(iotests.test_dir, 'quorum1.img'),
         os.path.join(iotests.test_dir, 'quorum2.img'))
diff --git a/tests/qemu-iotests/149 b/tests/qemu-iotests/149
index c13343d7ef9..2535f964243 100755
--- a/tests/qemu-iotests/149
+++ b/tests/qemu-iotests/149
@@ -21,16 +21,15 @@
 # Exercise the QEMU 'luks' block driver to validate interoperability
 # with the Linux dm-crypt + cryptsetup implementation
 
-import subprocess
+import base64
 import os
 import os.path
-
-import base64
+import subprocess
 
 import iotests
 
 
-class LUKSConfig(object):
+class LUKSConfig:
     """Represent configuration parameters for a single LUKS
        setup to be tested"""
 
diff --git a/tests/qemu-iotests/151 b/tests/qemu-iotests/151
index f2ff9c5dac2..84813f66ba5 100755
--- a/tests/qemu-iotests/151
+++ b/tests/qemu-iotests/151
@@ -23,10 +23,12 @@ import math
 import os
 import subprocess
 import time
-from typing import List, Optional
+from typing import Optional
+
 import iotests
 from iotests import qemu_img
 
+
 source_img = os.path.join(iotests.test_dir, 'source.' + iotests.imgfmt)
 target_img = os.path.join(iotests.test_dir, 'target.' + iotests.imgfmt)
 
@@ -195,7 +197,7 @@ class TestActiveMirror(iotests.QMPTestCase):
 class TestThrottledWithNbdExportBase(iotests.QMPTestCase):
     image_len = 128 * 1024 * 1024  # MB
     iops: Optional[int] = None
-    background_processes: List['subprocess.Popen[str]'] = []
+    background_processes: list['subprocess.Popen[str]'] = []
 
     def setUp(self):
         # Must be set by subclasses
diff --git a/tests/qemu-iotests/152 b/tests/qemu-iotests/152
index 197bea9e778..051d81590ea 100755
--- a/tests/qemu-iotests/152
+++ b/tests/qemu-iotests/152
@@ -20,9 +20,11 @@
 #
 
 import os
+
 import iotests
 from iotests import qemu_img
 
+
 test_img = os.path.join(iotests.test_dir, 'test.img')
 target_img = os.path.join(iotests.test_dir, 'target.img')
 
diff --git a/tests/qemu-iotests/155 b/tests/qemu-iotests/155
index 38eacb41272..c09a443c99f 100755
--- a/tests/qemu-iotests/155
+++ b/tests/qemu-iotests/155
@@ -23,9 +23,11 @@
 #
 
 import os
+
 import iotests
 from iotests import qemu_img
 
+
 back0_img = os.path.join(iotests.test_dir, 'back0.' + iotests.imgfmt)
 back1_img = os.path.join(iotests.test_dir, 'back1.' + iotests.imgfmt)
 back2_img = os.path.join(iotests.test_dir, 'back2.' + iotests.imgfmt)
diff --git a/tests/qemu-iotests/163 b/tests/qemu-iotests/163
index c94ad16f4a7..78e207be4fa 100755
--- a/tests/qemu-iotests/163
+++ b/tests/qemu-iotests/163
@@ -19,8 +19,15 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import os, random, iotests, struct, qcow2, sys
-from iotests import qemu_img, qemu_io, image_size
+import os
+import random
+import struct
+
+import qcow2
+
+import iotests
+from iotests import image_size, qemu_img, qemu_io
+
 
 test_img = os.path.join(iotests.test_dir, 'test.img')
 check_img = os.path.join(iotests.test_dir, 'check.img')
diff --git a/tests/qemu-iotests/165 b/tests/qemu-iotests/165
index b3b1709d71f..f0498286a61 100755
--- a/tests/qemu-iotests/165
+++ b/tests/qemu-iotests/165
@@ -20,10 +20,11 @@
 #
 
 import os
-import re
+
 import iotests
 from iotests import qemu_img
 
+
 disk = os.path.join(iotests.test_dir, 'disk')
 disk_size = 0x40000000 # 1G
 
diff --git a/tests/qemu-iotests/194 b/tests/qemu-iotests/194
index e114c0b2695..c27f860860b 100755
--- a/tests/qemu-iotests/194
+++ b/tests/qemu-iotests/194
@@ -22,6 +22,7 @@
 
 import iotests
 
+
 iotests.script_initialize(supported_fmts=['qcow2', 'qed', 'raw'],
                           supported_platforms=['linux'])
 
@@ -41,7 +42,7 @@ with iotests.FilePath('source.img') as source_img_path, \
     (source_vm.add_drive(source_img_path)
               .launch())
     (dest_vm.add_drive(dest_img_path)
-            .add_incoming('unix:{0}'.format(migration_sock_path))
+            .add_incoming(f'unix:{migration_sock_path}')
             .launch())
 
     source_vm.qmp_log('block-dirty-bitmap-add', node='drive0', name='bitmap0')
@@ -54,7 +55,7 @@ with iotests.FilePath('source.img') as source_img_path, \
     iotests.log(source_vm.qmp(
                   'drive-mirror',
                   device='drive0',
-                  target='nbd+unix:///drive0?socket={0}'.format(nbd_sock_path),
+                  target=f'nbd+unix:///drive0?socket={nbd_sock_path}',
                   sync='full',
                   format='raw', # always raw, the server handles the format
                   mode='existing',
@@ -70,7 +71,7 @@ with iotests.FilePath('source.img') as source_img_path, \
                     {'capability': 'dirty-bitmaps', 'state': True}]
     source_vm.qmp('migrate-set-capabilities', capabilities=capabilities)
     dest_vm.qmp('migrate-set-capabilities', capabilities=capabilities)
-    iotests.log(source_vm.qmp('migrate', uri='unix:{0}'.format(migration_sock_path)))
+    iotests.log(source_vm.qmp('migrate', uri=f'unix:{migration_sock_path}'))
 
     source_vm.qmp_log('migrate-start-postcopy')
 
diff --git a/tests/qemu-iotests/196 b/tests/qemu-iotests/196
index e5105b13543..71c1bae16a3 100755
--- a/tests/qemu-iotests/196
+++ b/tests/qemu-iotests/196
@@ -21,9 +21,11 @@
 #
 
 import os
+
 import iotests
 from iotests import qemu_img
 
+
 disk = os.path.join(iotests.test_dir, 'disk')
 migfile = os.path.join(iotests.test_dir, 'migfile')
 
diff --git a/tests/qemu-iotests/202 b/tests/qemu-iotests/202
index 13304242e5c..5f14658eca8 100755
--- a/tests/qemu-iotests/202
+++ b/tests/qemu-iotests/202
@@ -25,6 +25,7 @@
 
 import iotests
 
+
 iotests.script_initialize(supported_fmts=['qcow2'],
                           supported_platforms=['linux'])
 
diff --git a/tests/qemu-iotests/203 b/tests/qemu-iotests/203
index 1ba878522b0..c80d5b6b408 100755
--- a/tests/qemu-iotests/203
+++ b/tests/qemu-iotests/203
@@ -26,6 +26,7 @@
 
 import iotests
 
+
 iotests.script_initialize(supported_fmts=['qcow2'],
                           supported_platforms=['linux'])
 
diff --git a/tests/qemu-iotests/205 b/tests/qemu-iotests/205
index 2370e1a138b..4cf992c2a6a 100755
--- a/tests/qemu-iotests/205
+++ b/tests/qemu-iotests/205
@@ -20,10 +20,15 @@
 #
 
 import os
-import sys
+
 import iotests
-import time
-from iotests import qemu_img_create, qemu_io, filter_qemu_io, QemuIoInteractive
+from iotests import (
+    QemuIoInteractive,
+    filter_qemu_io,
+    qemu_img_create,
+    qemu_io,
+)
+
 
 nbd_sock = os.path.join(iotests.sock_dir, 'nbd_sock')
 nbd_uri = 'nbd+unix:///exp?socket=' + nbd_sock
diff --git a/tests/qemu-iotests/206 b/tests/qemu-iotests/206
index 10eff343f76..305021918d1 100755
--- a/tests/qemu-iotests/206
+++ b/tests/qemu-iotests/206
@@ -24,6 +24,7 @@
 import iotests
 from iotests import imgfmt
 
+
 iotests.script_initialize(supported_fmts=['qcow2'],
                           supported_protocols=['file'])
 iotests.verify_working_luks()
diff --git a/tests/qemu-iotests/207 b/tests/qemu-iotests/207
index 41dcf3ff55e..ef36c5d23c6 100755
--- a/tests/qemu-iotests/207
+++ b/tests/qemu-iotests/207
@@ -21,9 +21,11 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import iotests
-import subprocess
 import re
+import subprocess
+
+import iotests
+
 
 iotests.script_initialize(
     supported_fmts=['raw'],
diff --git a/tests/qemu-iotests/208 b/tests/qemu-iotests/208
index 6117f165fad..5159c44a52c 100755
--- a/tests/qemu-iotests/208
+++ b/tests/qemu-iotests/208
@@ -23,6 +23,7 @@
 
 import iotests
 
+
 iotests.script_initialize(supported_fmts=['generic'])
 
 with iotests.FilePath('disk.img') as disk_img_path, \
diff --git a/tests/qemu-iotests/209 b/tests/qemu-iotests/209
index f6ad08ec42a..379fd458834 100755
--- a/tests/qemu-iotests/209
+++ b/tests/qemu-iotests/209
@@ -20,8 +20,15 @@
 #
 
 import iotests
-from iotests import qemu_img_create, qemu_io, qemu_img_log, qemu_nbd, \
-                    file_path, log
+from iotests import (
+    file_path,
+    log,
+    qemu_img_create,
+    qemu_img_log,
+    qemu_io,
+    qemu_nbd,
+)
+
 
 iotests.script_initialize(supported_fmts=['qcow2'])
 
diff --git a/tests/qemu-iotests/210 b/tests/qemu-iotests/210
index 10b0a0b87cd..2a8c4a7393a 100755
--- a/tests/qemu-iotests/210
+++ b/tests/qemu-iotests/210
@@ -24,6 +24,7 @@
 import iotests
 from iotests import imgfmt
 
+
 iotests.script_initialize(
     supported_fmts=['luks'],
     supported_protocols=['file'],
diff --git a/tests/qemu-iotests/211 b/tests/qemu-iotests/211
index 1a3b4596c80..e01c6c1a0b9 100755
--- a/tests/qemu-iotests/211
+++ b/tests/qemu-iotests/211
@@ -24,6 +24,7 @@
 import iotests
 from iotests import imgfmt
 
+
 iotests.script_initialize(
     supported_fmts=['vdi'],
     supported_protocols=['file'],
diff --git a/tests/qemu-iotests/212 b/tests/qemu-iotests/212
index d4af0c4ac80..099c5bae173 100755
--- a/tests/qemu-iotests/212
+++ b/tests/qemu-iotests/212
@@ -24,6 +24,7 @@
 import iotests
 from iotests import imgfmt
 
+
 iotests.script_initialize(
     supported_fmts=['parallels'],
     supported_protocols=['file'],
diff --git a/tests/qemu-iotests/213 b/tests/qemu-iotests/213
index 78d839ab641..155895ca8ff 100755
--- a/tests/qemu-iotests/213
+++ b/tests/qemu-iotests/213
@@ -24,6 +24,7 @@
 import iotests
 from iotests import imgfmt
 
+
 iotests.script_initialize(
     supported_fmts=['vhdx'],
     supported_protocols=['file'],
diff --git a/tests/qemu-iotests/216 b/tests/qemu-iotests/216
index 311e02af3a7..1bbac175999 100755
--- a/tests/qemu-iotests/216
+++ b/tests/qemu-iotests/216
@@ -23,6 +23,7 @@
 import iotests
 from iotests import log, qemu_img, qemu_io
 
+
 # Need backing file support
 iotests.script_initialize(supported_fmts=['qcow2', 'qcow', 'qed', 'vmdk'],
                           supported_platforms=['linux'])
diff --git a/tests/qemu-iotests/218 b/tests/qemu-iotests/218
index 81aa68806f5..7860f448694 100755
--- a/tests/qemu-iotests/218
+++ b/tests/qemu-iotests/218
@@ -30,6 +30,7 @@
 import iotests
 from iotests import log, qemu_img, qemu_io
 
+
 iotests.script_initialize(supported_fmts=['qcow2', 'raw'])
 
 
diff --git a/tests/qemu-iotests/219 b/tests/qemu-iotests/219
index d1757e9e6fc..3c36f5d68c7 100755
--- a/tests/qemu-iotests/219
+++ b/tests/qemu-iotests/219
@@ -22,6 +22,7 @@
 
 import iotests
 
+
 iotests.script_initialize(supported_fmts=['qcow2'])
 
 img_size = 4 * 1024 * 1024
diff --git a/tests/qemu-iotests/224 b/tests/qemu-iotests/224
index 542d0eefa60..7d6b88c2db5 100755
--- a/tests/qemu-iotests/224
+++ b/tests/qemu-iotests/224
@@ -21,11 +21,18 @@
 #
 # Creator/Owner: Hanna Reitz <hreitz@redhat.com>
 
-import iotests
-from iotests import log, qemu_img, qemu_io, filter_qmp_testfiles, \
-                    filter_qmp_imgfmt
 import json
 
+import iotests
+from iotests import (
+    filter_qmp_imgfmt,
+    filter_qmp_testfiles,
+    log,
+    qemu_img,
+    qemu_io,
+)
+
+
 # Need backing file support (for arbitrary backing formats)
 iotests.script_initialize(supported_fmts=['qcow2', 'qcow', 'qed'],
                           supported_platforms=['linux'])
diff --git a/tests/qemu-iotests/228 b/tests/qemu-iotests/228
index 7341777f9f1..acdb5362e03 100755
--- a/tests/qemu-iotests/228
+++ b/tests/qemu-iotests/228
@@ -22,8 +22,15 @@
 # Creator/Owner: Hanna Reitz <hreitz@redhat.com>
 
 import iotests
-from iotests import log, qemu_img, filter_testfiles, filter_imgfmt, \
-        filter_qmp_testfiles, filter_qmp_imgfmt
+from iotests import (
+    filter_imgfmt,
+    filter_qmp_imgfmt,
+    filter_qmp_testfiles,
+    filter_testfiles,
+    log,
+    qemu_img,
+)
+
 
 # Need backing file and change-backing-file support
 iotests.script_initialize(
diff --git a/tests/qemu-iotests/234 b/tests/qemu-iotests/234
index a9f764bb2c6..b5926b9fdef 100755
--- a/tests/qemu-iotests/234
+++ b/tests/qemu-iotests/234
@@ -21,9 +21,11 @@
 # Check that block node activation and inactivation works with a block graph
 # that is built with individually created nodes
 
-import iotests
 import os
 
+import iotests
+
+
 iotests.script_initialize(supported_fmts=['qcow2'],
                           supported_platforms=['linux'])
 
diff --git a/tests/qemu-iotests/235 b/tests/qemu-iotests/235
index 4de920c3801..04ed2e41d72 100755
--- a/tests/qemu-iotests/235
+++ b/tests/qemu-iotests/235
@@ -19,13 +19,17 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import sys
-import os
-import iotests
-from iotests import qemu_img_create, qemu_io, file_path, log
-
 from qemu.machine import QEMUMachine
 
+import iotests
+from iotests import (
+    file_path,
+    log,
+    qemu_img_create,
+    qemu_io,
+)
+
+
 iotests.script_initialize(supported_fmts=['qcow2'])
 
 # Note:
diff --git a/tests/qemu-iotests/236 b/tests/qemu-iotests/236
index 20419bbb9e5..f872d8356e0 100755
--- a/tests/qemu-iotests/236
+++ b/tests/qemu-iotests/236
@@ -23,6 +23,7 @@
 import iotests
 from iotests import log
 
+
 iotests.script_initialize(supported_fmts=['generic'])
 size = 64 * 1024 * 1024
 granularity = 64 * 1024
diff --git a/tests/qemu-iotests/237 b/tests/qemu-iotests/237
index 5ea13eb01fc..a6deb844f6a 100755
--- a/tests/qemu-iotests/237
+++ b/tests/qemu-iotests/237
@@ -22,9 +22,11 @@
 #
 
 import math
+
 import iotests
 from iotests import imgfmt
 
+
 iotests.script_initialize(supported_fmts=['vmdk'])
 
 with iotests.FilePath('t.vmdk') as disk_path, \
diff --git a/tests/qemu-iotests/238 b/tests/qemu-iotests/238
index 38bd3744e68..c053fc3ae80 100755
--- a/tests/qemu-iotests/238
+++ b/tests/qemu-iotests/238
@@ -19,11 +19,10 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import sys
-import os
 import iotests
 from iotests import log
 
+
 iotests.script_initialize()
 
 vm = iotests.VM()
diff --git a/tests/qemu-iotests/240 b/tests/qemu-iotests/240
index f8af9ff648e..124be255dd7 100755
--- a/tests/qemu-iotests/240
+++ b/tests/qemu-iotests/240
@@ -20,7 +20,7 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 import iotests
-import os
+
 
 nbd_sock = iotests.file_path('nbd.sock', base_dir=iotests.sock_dir)
 
diff --git a/tests/qemu-iotests/242 b/tests/qemu-iotests/242
index c89f0c6cb32..47fdc86600c 100755
--- a/tests/qemu-iotests/242
+++ b/tests/qemu-iotests/242
@@ -19,11 +19,18 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import iotests
-import json
 import struct
-from iotests import qemu_img_create, qemu_io_log, qemu_img_info, \
-    file_path, img_info_log, log
+
+import iotests
+from iotests import (
+    file_path,
+    img_info_log,
+    log,
+    qemu_img_create,
+    qemu_img_info,
+    qemu_io_log,
+)
+
 
 iotests.script_initialize(supported_fmts=['qcow2'],
                           supported_protocols=['file'],
@@ -60,7 +67,7 @@ def add_bitmap(bitmap_number, persistent, disabled):
 
 
 def write_to_disk(offset, size):
-    write = 'write {} {}'.format(offset, size)
+    write = f'write {offset} {size}'
     qemu_io_log('-c', write, disk)
 
 
@@ -80,7 +87,7 @@ for num in range(1, 4):
     disabled = False
     if num == 2:
         disabled = True
-    log('Test {}'.format(num))
+    log(f'Test {num}')
     add_bitmap(num, num > 1, disabled)
     write_to_disk((num-1) * chunk, chunk)
     print_bitmap([])
@@ -89,12 +96,12 @@ for num in range(1, 4):
 vm = iotests.VM().add_drive(disk)
 vm.launch()
 num += 1
-log('Test {}\nChecking "in-use" flag...'.format(num))
+log(f'Test {num}\nChecking "in-use" flag...')
 print_bitmap(['--force-share'])
 vm.shutdown()
 
 num += 1
-log('\nTest {}'.format(num))
+log(f'\nTest {num}')
 qemu_img_create('-f', iotests.imgfmt, disk, '1M')
 add_bitmap(1, True, False)
 log('Write an unknown bitmap flag \'{}\' into a new QCOW2 image at offset {}'
diff --git a/tests/qemu-iotests/245 b/tests/qemu-iotests/245
index f96610f5109..1be4034e8da 100755
--- a/tests/qemu-iotests/245
+++ b/tests/qemu-iotests/245
@@ -29,6 +29,7 @@ from subprocess import CalledProcessError
 import iotests
 from iotests import qemu_img, qemu_io
 
+
 hd_path = [
     os.path.join(iotests.test_dir, 'hd0.img'),
     os.path.join(iotests.test_dir, 'hd1.img'),
diff --git a/tests/qemu-iotests/246 b/tests/qemu-iotests/246
index b009a783977..09b9c0968c1 100755
--- a/tests/qemu-iotests/246
+++ b/tests/qemu-iotests/246
@@ -23,6 +23,7 @@
 import iotests
 from iotests import log
 
+
 iotests.script_initialize(supported_fmts=['qcow2'],
                           unsupported_imgopts=['compat'])
 size = 64 * 1024 * 1024 * 1024
diff --git a/tests/qemu-iotests/248 b/tests/qemu-iotests/248
index 2ec2416e8a0..73778a1316e 100755
--- a/tests/qemu-iotests/248
+++ b/tests/qemu-iotests/248
@@ -20,7 +20,13 @@
 #
 
 import iotests
-from iotests import qemu_img_create, qemu_io, file_path, filter_qmp_testfiles
+from iotests import (
+    file_path,
+    filter_qmp_testfiles,
+    qemu_img_create,
+    qemu_io,
+)
+
 
 iotests.script_initialize(supported_fmts=['qcow2'])
 
@@ -30,10 +36,10 @@ limit = 2 * 1024 * 1024
 
 qemu_img_create('-f', iotests.imgfmt, source, str(size))
 qemu_img_create('-f', iotests.imgfmt, target, str(size))
-qemu_io('-c', 'write 0 {}'.format(size), source)
+qemu_io('-c', f'write 0 {size}', source)
 
 # raw format don't like empty files
-qemu_io('-c', 'write 0 {}'.format(size), target)
+qemu_io('-c', f'write 0 {size}', target)
 
 vm = iotests.VM().add_drive(source)
 vm.launch()
diff --git a/tests/qemu-iotests/254 b/tests/qemu-iotests/254
index 7ea098818cf..5fda141b94f 100755
--- a/tests/qemu-iotests/254
+++ b/tests/qemu-iotests/254
@@ -20,7 +20,8 @@
 #
 
 import iotests
-from iotests import qemu_img_create, file_path, log
+from iotests import file_path, log, qemu_img_create
+
 
 iotests.script_initialize(supported_fmts=['qcow2'],
                           unsupported_imgopts=['compat'])
diff --git a/tests/qemu-iotests/255 b/tests/qemu-iotests/255
index 88b29d64b44..5e4f25688d1 100755
--- a/tests/qemu-iotests/255
+++ b/tests/qemu-iotests/255
@@ -24,6 +24,7 @@
 import iotests
 from iotests import imgfmt
 
+
 iotests.script_initialize(supported_fmts=['qcow2'])
 
 iotests.log('Finishing a commit job with background reads')
diff --git a/tests/qemu-iotests/256 b/tests/qemu-iotests/256
index f34af6cef7a..09b375269f6 100755
--- a/tests/qemu-iotests/256
+++ b/tests/qemu-iotests/256
@@ -21,9 +21,11 @@
 # owner=jsnow@redhat.com
 
 import os
+
 import iotests
 from iotests import log
 
+
 iotests.verify_virtio_scsi_pci_or_ccw()
 
 iotests.script_initialize(supported_fmts=['qcow2'])
@@ -39,7 +41,7 @@ with iotests.FilePath('img0') as img0_path, \
 
     def create_target(filepath, name, size):
         basename = os.path.basename(filepath)
-        nodename = "file_{}".format(basename)
+        nodename = f"file_{basename}"
         log(vm.cmd('blockdev-create', job_id='job1',
                    options={
                        'driver': 'file',
diff --git a/tests/qemu-iotests/257 b/tests/qemu-iotests/257
index 7d3720b8e59..e2a957c4ab1 100755
--- a/tests/qemu-iotests/257
+++ b/tests/qemu-iotests/257
@@ -20,12 +20,12 @@
 #
 # owner=jsnow@redhat.com
 
-import math
 import os
 
 import iotests
 from iotests import log, qemu_img
 
+
 SIZE = 64 * 1024 * 1024
 GRANULARITY = 64 * 1024
 
@@ -129,7 +129,7 @@ class EmulatedBitmap:
         """
 
         name = qmp_bitmap.get('name', '(anonymous)')
-        log("= Checking Bitmap {:s} =".format(name))
+        log(f"= Checking Bitmap {name:s} =")
 
         want = self.count
         have = qmp_bitmap['count'] // qmp_bitmap['granularity']
@@ -157,7 +157,7 @@ class Drive:
 
     def create_target(self, name, fmt, size):
         basename = os.path.basename(self.path)
-        file_node_name = "file_{}".format(basename)
+        file_node_name = f"file_{basename}"
         vm = self.vm
 
         log(vm.cmd('blockdev-create', job_id='bdc-file-job',
@@ -202,25 +202,25 @@ def blockdev_backup_mktarget(drive, target_id, filepath, sync, **kwargs):
     blockdev_backup(drive.vm, drive.node, target_id, sync, **kwargs)
 
 def reference_backup(drive, n, filepath):
-    log("--- Reference Backup #{:d} ---\n".format(n))
-    target_id = "ref_target_{:d}".format(n)
-    job_id = "ref_backup_{:d}".format(n)
+    log(f"--- Reference Backup #{n:d} ---\n")
+    target_id = f"ref_target_{n:d}"
+    job_id = f"ref_backup_{n:d}"
     blockdev_backup_mktarget(drive, target_id, filepath, "full",
                              job_id=job_id)
     drive.vm.run_job(job_id, auto_dismiss=True)
     log('')
 
 def backup(drive, n, filepath, sync, **kwargs):
-    log("--- Test Backup #{:d} ---\n".format(n))
-    target_id = "backup_target_{:d}".format(n)
-    job_id = "backup_{:d}".format(n)
+    log(f"--- Test Backup #{n:d} ---\n")
+    target_id = f"backup_target_{n:d}"
+    job_id = f"backup_{n:d}"
     kwargs.setdefault('auto-finalize', False)
     blockdev_backup_mktarget(drive, target_id, filepath, sync,
                              job_id=job_id, **kwargs)
     return job_id
 
 def perform_writes(drive, n, filter_node_name=None):
-    log("--- Write #{:d} ---\n".format(n))
+    log(f"--- Write #{n:d} ---\n")
     for pattern in GROUPS[n].patterns:
         cmd = "write -P{:s} 0x{:07x} 0x{:x}".format(
             pattern.byte,
@@ -283,12 +283,12 @@ def test_bitmap_sync(bsync_mode, msync_mode='bitmap', failure=None):
             (img_path, bsync1, bsync2, fbackup0, fbackup1, fbackup2), \
          iotests.VM() as vm:
 
-        mode = "Mode {:s}; Bitmap Sync {:s}".format(msync_mode, bsync_mode)
+        mode = f"Mode {msync_mode:s}; Bitmap Sync {bsync_mode:s}"
         preposition = "with" if failure else "without"
         cond = "{:s} {:s}".format(preposition,
-                                  "{:s} failure".format(failure) if failure
+                                  f"{failure:s} failure" if failure
                                   else "failure")
-        log("\n=== {:s} {:s} ===\n".format(mode, cond))
+        log(f"\n=== {mode:s} {cond:s} ===\n")
 
         log('--- Preparing image & VM ---\n')
         drive0 = Drive(img_path, vm=vm)
@@ -506,7 +506,7 @@ def test_backup_api():
 
         # Dicts, as always, are not stably-ordered prior to 3.7, so use tuples:
         for sync_mode in ('incremental', 'bitmap', 'full', 'top', 'none'):
-            log("-- Sync mode {:s} tests --\n".format(sync_mode))
+            log(f"-- Sync mode {sync_mode:s} tests --\n")
             for bitmap in (None, 'bitmap404', 'bitmap0'):
                 for policy in error_cases[sync_mode][bitmap]:
                     blockdev_backup(drive0.vm, drive0.node, "backup_target",
diff --git a/tests/qemu-iotests/258 b/tests/qemu-iotests/258
index 73d4af645f0..2795c719402 100755
--- a/tests/qemu-iotests/258
+++ b/tests/qemu-iotests/258
@@ -21,8 +21,14 @@
 # Creator/Owner: Hanna Reitz <hreitz@redhat.com>
 
 import iotests
-from iotests import log, qemu_img, qemu_io, \
-        filter_qmp_testfiles, filter_qmp_imgfmt
+from iotests import (
+    filter_qmp_imgfmt,
+    filter_qmp_testfiles,
+    log,
+    qemu_img,
+    qemu_io,
+)
+
 
 # Returns a node for blockdev-add
 def node(node_name, path, backing=None, fmt=None, throttle=None):
diff --git a/tests/qemu-iotests/260 b/tests/qemu-iotests/260
index c2133f99801..2702700a823 100755
--- a/tests/qemu-iotests/260
+++ b/tests/qemu-iotests/260
@@ -20,7 +20,13 @@
 #
 
 import iotests
-from iotests import qemu_img_create, file_path, log, filter_qmp_event
+from iotests import (
+    file_path,
+    filter_qmp_event,
+    log,
+    qemu_img_create,
+)
+
 
 iotests.script_initialize(
     supported_fmts=['qcow2'],
diff --git a/tests/qemu-iotests/262 b/tests/qemu-iotests/262
index a4a92de45a1..d348c08485f 100755
--- a/tests/qemu-iotests/262
+++ b/tests/qemu-iotests/262
@@ -21,9 +21,11 @@
 # Test migration with filter drivers present. Keep everything in an
 # iothread just for fun.
 
-import iotests
 import os
 
+import iotests
+
+
 iotests.script_initialize(supported_fmts=['qcow2'],
                           supported_platforms=['linux'],
                           required_fmts=['blkverify'])
diff --git a/tests/qemu-iotests/264 b/tests/qemu-iotests/264
index c6ba2754e27..2628f1ae312 100755
--- a/tests/qemu-iotests/264
+++ b/tests/qemu-iotests/264
@@ -19,11 +19,12 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import time
 import os
+import time
 
 import iotests
-from iotests import qemu_img_create, file_path, qemu_nbd_popen
+from iotests import file_path, qemu_img_create, qemu_nbd_popen
+
 
 disk_a, disk_b = file_path('disk_a', 'disk_b')
 nbd_sock = file_path('nbd-sock', base_dir=iotests.sock_dir)
@@ -38,7 +39,7 @@ class TestNbdReconnect(iotests.QMPTestCase):
         qemu_img_create('-f', iotests.imgfmt, disk_b, str(disk_size))
         self.vm = iotests.VM().add_drive(disk_a)
         self.vm.launch()
-        self.vm.hmp_qemu_io('drive0', 'write 0 {}'.format(disk_size))
+        self.vm.hmp_qemu_io('drive0', f'write 0 {disk_size}')
 
     def tearDown(self):
         self.vm.shutdown()
diff --git a/tests/qemu-iotests/274 b/tests/qemu-iotests/274
index 2495e051a22..ec573c6a314 100755
--- a/tests/qemu-iotests/274
+++ b/tests/qemu-iotests/274
@@ -22,6 +22,7 @@
 
 import iotests
 
+
 iotests.script_initialize(supported_fmts=['qcow2'],
                           supported_platforms=['linux'],
                           unsupported_imgopts=['refcount_bits', 'compat'])
diff --git a/tests/qemu-iotests/277 b/tests/qemu-iotests/277
index 4224202ac2c..07d1d763430 100755
--- a/tests/qemu-iotests/277
+++ b/tests/qemu-iotests/277
@@ -21,9 +21,11 @@
 
 import os
 import subprocess
+
 import iotests
 from iotests import file_path, log
 
+
 iotests.script_initialize()
 
 
@@ -38,7 +40,7 @@ def make_conf_file(event):
     :param event: which event the server should close a connection on
     """
     with open(conf_file, 'w') as conff:
-        conff.write('[inject-error]\nevent={}\nwhen=after'.format(event))
+        conff.write(f'[inject-error]\nevent={event}\nwhen=after')
 
 
 def start_server_NBD(event):
@@ -73,15 +75,15 @@ def check_proc_NBD(proc, connector):
         outs, errs = proc.communicate(timeout=10)
 
         if proc.returncode < 0:
-            log('NBD {}: EXIT SIGNAL {}\n'.format(connector, proc.returncode))
+            log(f'NBD {connector}: EXIT SIGNAL {proc.returncode}\n')
             log(outs)
         else:
             msg = outs.split('\n', 1)
-            log('NBD {}: {}'.format(connector, msg[0]))
+            log(f'NBD {connector}: {msg[0]}')
 
     except subprocess.TimeoutExpired:
         proc.kill()
-        log('NBD {}: ERROR timeout expired'.format(connector))
+        log(f'NBD {connector}: ERROR timeout expired')
     finally:
         if connector == 'server':
             os.remove(nbd_sock)
diff --git a/tests/qemu-iotests/280 b/tests/qemu-iotests/280
index 5f50500fdb8..9a0eaef5e19 100755
--- a/tests/qemu-iotests/280
+++ b/tests/qemu-iotests/280
@@ -21,7 +21,7 @@
 # Test migration to file for taking an external snapshot with VM state.
 
 import iotests
-import os
+
 
 iotests.script_initialize(
     supported_fmts=['qcow2'],
diff --git a/tests/qemu-iotests/281 b/tests/qemu-iotests/281
index f6746a12e88..b4468178cd6 100755
--- a/tests/qemu-iotests/281
+++ b/tests/qemu-iotests/281
@@ -21,8 +21,10 @@
 
 import os
 import time
+
 import iotests
-from iotests import qemu_img, QemuStorageDaemon
+from iotests import QemuStorageDaemon, qemu_img
+
 
 image_len = 64 * 1024 * 1024
 
diff --git a/tests/qemu-iotests/283 b/tests/qemu-iotests/283
index 5defe48e97d..501495275df 100755
--- a/tests/qemu-iotests/283
+++ b/tests/qemu-iotests/283
@@ -21,6 +21,7 @@
 
 import iotests
 
+
 # The test is unrelated to formats, restrict it to qcow2 to avoid extra runs
 iotests.script_initialize(
     supported_fmts=['qcow2'],
diff --git a/tests/qemu-iotests/295 b/tests/qemu-iotests/295
index 04818af2649..0c965ef176f 100755
--- a/tests/qemu-iotests/295
+++ b/tests/qemu-iotests/295
@@ -19,10 +19,10 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import iotests
 import os
-import time
-import json
+
+import iotests
+
 
 test_img = os.path.join(iotests.test_dir, 'test.img')
 
diff --git a/tests/qemu-iotests/296 b/tests/qemu-iotests/296
index 2b63cefff0e..be6b97025b3 100755
--- a/tests/qemu-iotests/296
+++ b/tests/qemu-iotests/296
@@ -19,10 +19,11 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import iotests
-import os
-import time
 import json
+import os
+
+import iotests
+
 
 test_img = os.path.join(iotests.test_dir, 'test.img')
 
diff --git a/tests/qemu-iotests/297 b/tests/qemu-iotests/297
index ee78a627359..421c3cd1b71 100755
--- a/tests/qemu-iotests/297
+++ b/tests/qemu-iotests/297
@@ -19,11 +19,11 @@
 import os
 import subprocess
 import sys
-from typing import List
 
-import iotests
 import linters
 
+import iotests
+
 
 # Looking for something?
 #
@@ -41,7 +41,7 @@ def check_linter(linter: str) -> bool:
     return True
 
 
-def test_pylint(files: List[str]) -> None:
+def test_pylint(files: list[str]) -> None:
     print('=== pylint ===')
     sys.stdout.flush()
 
@@ -51,7 +51,7 @@ def test_pylint(files: List[str]) -> None:
     linters.run_linter('pylint', files)
 
 
-def test_mypy(files: List[str]) -> None:
+def test_mypy(files: list[str]) -> None:
     print('=== mypy ===')
     sys.stdout.flush()
 
diff --git a/tests/qemu-iotests/298 b/tests/qemu-iotests/298
index 09c9290711a..0d83f43156c 100755
--- a/tests/qemu-iotests/298
+++ b/tests/qemu-iotests/298
@@ -19,8 +19,10 @@
 #
 
 import os
+
 import iotests
 
+
 MiB = 1024 * 1024
 disk = os.path.join(iotests.test_dir, 'disk')
 overlay = os.path.join(iotests.test_dir, 'overlay')
diff --git a/tests/qemu-iotests/299 b/tests/qemu-iotests/299
index a7122941fd2..0deb628ba57 100755
--- a/tests/qemu-iotests/299
+++ b/tests/qemu-iotests/299
@@ -21,6 +21,7 @@
 
 import iotests
 
+
 # The test is unrelated to formats, restrict it to qcow2 to avoid extra runs
 iotests.script_initialize(
     supported_fmts=['qcow2'],
diff --git a/tests/qemu-iotests/300 b/tests/qemu-iotests/300
index e46616d7b19..914eea64f2f 100755
--- a/tests/qemu-iotests/300
+++ b/tests/qemu-iotests/300
@@ -22,12 +22,12 @@
 import os
 import random
 import re
-from typing import Dict, List, Optional
+from typing import Optional
 
 import iotests
 
 
-BlockBitmapMapping = List[Dict[str, object]]
+BlockBitmapMapping = list[dict[str, object]]
 
 mig_sock = os.path.join(iotests.sock_dir, 'mig_sock')
 
@@ -565,7 +565,7 @@ class TestCrossAliasMigration(TestDirtyBitmapMigration):
 
         # Extract and sort bitmap names
         for node in bitmaps:
-            bitmaps[node] = sorted((bmap['name'] for bmap in bitmaps[node]))
+            bitmaps[node] = sorted(bmap['name'] for bmap in bitmaps[node])
 
         self.assertEqual(bitmaps,
                          {'node-a': ['bmap-a', 'bmap-b'],
@@ -661,8 +661,8 @@ class TestAliasTransformMigration(TestDirtyBitmapMigration):
         bitmaps = self.vm_b.query_bitmaps()
 
         for node in bitmaps:
-            bitmaps[node] = sorted(((bmap['name'], bmap['persistent'])
-                                    for bmap in bitmaps[node]))
+            bitmaps[node] = sorted((bmap['name'], bmap['persistent'])
+                                    for bmap in bitmaps[node])
 
         self.assertEqual(bitmaps,
                          {'node-a': [('bmap-a', True), ('bmap-b', False)],
diff --git a/tests/qemu-iotests/302 b/tests/qemu-iotests/302
index e980ec513f2..8b86d50075c 100755
--- a/tests/qemu-iotests/302
+++ b/tests/qemu-iotests/302
@@ -24,9 +24,9 @@ import io
 import tarfile
 
 import iotests
-
 from iotests import (
     file_path,
+    img_info_log,
     qemu_img,
     qemu_img_check,
     qemu_img_create,
@@ -34,9 +34,9 @@ from iotests import (
     qemu_img_measure,
     qemu_io,
     qemu_nbd_popen,
-    img_info_log,
 )
 
+
 iotests.script_initialize(supported_fmts=["qcow2"])
 
 # Create source disk. Using qcow2 to enable strict comparing later, and
diff --git a/tests/qemu-iotests/303 b/tests/qemu-iotests/303
index a8cc6a23dfe..12920956686 100755
--- a/tests/qemu-iotests/303
+++ b/tests/qemu-iotests/303
@@ -19,10 +19,17 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import iotests
 import subprocess
-from iotests import qemu_img_create, qemu_io_log, file_path, log, \
-        verify_qcow2_zstd_compression
+
+import iotests
+from iotests import (
+    file_path,
+    log,
+    qemu_img_create,
+    qemu_io_log,
+    verify_qcow2_zstd_compression,
+)
+
 
 iotests.script_initialize(supported_fmts=['qcow2'],
                           unsupported_imgopts=['refcount_bits', 'compat'])
diff --git a/tests/qemu-iotests/304 b/tests/qemu-iotests/304
index 198f2820871..f79cb53d62d 100755
--- a/tests/qemu-iotests/304
+++ b/tests/qemu-iotests/304
@@ -21,7 +21,8 @@
 # owner=s.reiter@proxmox.com
 
 import iotests
-from iotests import qemu_img_create, qemu_img_log, file_path
+from iotests import file_path, qemu_img_create, qemu_img_log
+
 
 iotests.script_initialize(supported_fmts=['qcow2'],
                           supported_protocols=['file'])
diff --git a/tests/qemu-iotests/307 b/tests/qemu-iotests/307
index b429b5aa50a..fdf98afee90 100755
--- a/tests/qemu-iotests/307
+++ b/tests/qemu-iotests/307
@@ -21,7 +21,7 @@
 # Test the block export QAPI interfaces
 
 import iotests
-import os
+
 
 # Need a writable image format (but not vpc, which rounds the image size, nor
 # luks which requires special command lines)
diff --git a/tests/qemu-iotests/310 b/tests/qemu-iotests/310
index 650d2cb6fb3..ad9a20b1722 100755
--- a/tests/qemu-iotests/310
+++ b/tests/qemu-iotests/310
@@ -23,6 +23,7 @@
 import iotests
 from iotests import log, qemu_img, qemu_io
 
+
 # Need backing file support
 iotests.script_initialize(supported_fmts=['qcow2'],
                           supported_platforms=['linux'])
diff --git a/tests/qemu-iotests/check b/tests/qemu-iotests/check
index 545f9ec7bdd..df7c818e0d5 100755
--- a/tests/qemu-iotests/check
+++ b/tests/qemu-iotests/check
@@ -16,16 +16,17 @@
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
-import os
-import sys
 import argparse
-import shutil
+import os
 from pathlib import Path
+import shutil
+import sys
 
 from findtests import TestFinder
 from testenv import TestEnv
 from testrunner import TestRunner
 
+
 def get_default_path(follow_link=False):
     """
     Try to automagically figure out the path we are running from.
diff --git a/tests/qemu-iotests/fat16.py b/tests/qemu-iotests/fat16.py
index 7d2d0524133..88c3d56c662 100644
--- a/tests/qemu-iotests/fat16.py
+++ b/tests/qemu-iotests/fat16.py
@@ -15,8 +15,9 @@
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
-from typing import Callable, List, Optional, Protocol, Set
 import string
+from typing import Callable, Optional, Protocol
+
 
 SECTOR_SIZE = 512
 DIRENTRY_SIZE = 32
@@ -227,7 +228,7 @@ def __init__(
         self.fats = self.read_sectors(
             self.boot_sector.reserved_sectors, fat_size_in_sectors
         )
-        self.fats_dirty_sectors: Set[int] = set()
+        self.fats_dirty_sectors: set[int] = set()
 
     def read_sectors(self, start_sector: int, num_sectors: int) -> bytes:
         return self.sector_reader(start_sector + self.start_sector,
@@ -238,7 +239,7 @@ def write_sectors(self, start_sector: int, data: bytes) -> None:
 
     def directory_from_bytes(
         self, data: bytes, start_sector: int
-    ) -> List[FatDirectoryEntry]:
+    ) -> list[FatDirectoryEntry]:
         """
         Convert `bytes` into a list of `FatDirectoryEntry` objects.
         Will ignore long file names.
@@ -268,7 +269,7 @@ def directory_from_bytes(
             )
         return entries
 
-    def read_root_directory(self) -> List[FatDirectoryEntry]:
+    def read_root_directory(self) -> list[FatDirectoryEntry]:
         root_dir = self.read_sectors(
             self.boot_sector.root_dir_start(), self.boot_sector.root_dir_size()
         )
@@ -373,7 +374,7 @@ def write_cluster(self, cluster: int, data: bytes) -> None:
 
     def read_directory(
         self, cluster: Optional[int]
-    ) -> List[FatDirectoryEntry]:
+    ) -> list[FatDirectoryEntry]:
         """
         Read the directory at the given cluster.
         """
diff --git a/tests/qemu-iotests/findtests.py b/tests/qemu-iotests/findtests.py
index dd77b453b8a..b444fc44255 100644
--- a/tests/qemu-iotests/findtests.py
+++ b/tests/qemu-iotests/findtests.py
@@ -16,12 +16,13 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import os
-import glob
-import re
 from collections import defaultdict
+from collections.abc import Iterator
 from contextlib import contextmanager
-from typing import Optional, List, Iterator, Set
+import glob
+import os
+import re
+from typing import Optional
 
 
 @contextmanager
@@ -89,10 +90,10 @@ def parse_test_name(self, name: str) -> str:
 
         return name
 
-    def find_tests(self, groups: Optional[List[str]] = None,
-                   exclude_groups: Optional[List[str]] = None,
-                   tests: Optional[List[str]] = None,
-                   start_from: Optional[str] = None) -> List[str]:
+    def find_tests(self, groups: Optional[list[str]] = None,
+                   exclude_groups: Optional[list[str]] = None,
+                   tests: Optional[list[str]] = None,
+                   start_from: Optional[str] = None) -> list[str]:
         """Find tests
 
         Algorithm:
@@ -123,7 +124,7 @@ def find_tests(self, groups: Optional[List[str]] = None,
         if tests is None:
             tests = []
 
-        res: Set[str] = set()
+        res: set[str] = set()
         if groups:
             # Some groups specified. exclude_groups supported, additionally
             # selecting some individual tests supported as well.
diff --git a/tests/qemu-iotests/iotests.py b/tests/qemu-iotests/iotests.py
index 05274772ce4..104a61058fa 100644
--- a/tests/qemu-iotests/iotests.py
+++ b/tests/qemu-iotests/iotests.py
@@ -20,6 +20,8 @@
 import atexit
 import bz2
 from collections import OrderedDict
+from collections.abc import Iterable, Iterator, Sequence
+from contextlib import contextmanager
 import faulthandler
 import json
 import logging
@@ -31,16 +33,24 @@
 import subprocess
 import sys
 import time
-from typing import (Any, Callable, Dict, Iterable, Iterator,
-                    List, Optional, Sequence, TextIO, Tuple, Type, TypeVar)
+from typing import (
+    Any,
+    Callable,
+    Optional,
+    TextIO,
+    TypeVar,
+)
 import unittest
 
-from contextlib import contextmanager
-
 from qemu.machine import qtest
-from qemu.qmp.legacy import QMPMessage, QMPReturnValue, QEMUMonitorProtocol
+from qemu.qmp.legacy import (
+    QEMUMonitorProtocol,
+    QMPMessage,
+    QMPReturnValue,
+)
 from qemu.utils import VerboseProcessError
 
+
 # Use this logger for logging messages directly from the iotests module
 logger = logging.getLogger('qemu.iotests')
 logger.addHandler(logging.NullHandler())
@@ -154,7 +164,7 @@ def qemu_tool_popen(args: Sequence[str],
 def qemu_tool_pipe_and_status(tool: str, args: Sequence[str],
                               connect_stderr: bool = True,
                               drop_successful_output: bool = False) \
-        -> Tuple[str, int]:
+        -> tuple[str, int]:
     """
     Run a tool and return both its output and its exit code
     """
@@ -168,7 +178,7 @@ def qemu_tool_pipe_and_status(tool: str, args: Sequence[str],
             output = ''
         return (output, subp.returncode)
 
-def qemu_img_create_prepare_args(args: List[str]) -> List[str]:
+def qemu_img_create_prepare_args(args: list[str]) -> list[str]:
     if not args or args[0] != 'create':
         return list(args)
     args = args[1:]
@@ -233,7 +243,7 @@ def qemu_tool(*args: str, check: bool = True, combine_stdio: bool = True
         args,
         stdout=subprocess.PIPE,
         stderr=subprocess.STDOUT if combine_stdio else subprocess.PIPE,
-        universal_newlines=True,
+        text=True,
         check=False
     )
 
@@ -344,7 +354,7 @@ def img_info_log(filename: str, filter_path: Optional[str] = None,
         filter_path = filename
     log(filter_img_info(output, filter_path, drop_child_info))
 
-def qemu_io_wrap_args(args: Sequence[str]) -> List[str]:
+def qemu_io_wrap_args(args: Sequence[str]) -> list[str]:
     if '-f' in args or '--image-opts' in args:
         return qemu_io_args_no_fmt + list(args)
     else:
@@ -457,7 +467,7 @@ def __init__(self, *args: str, instance_id: str = 'a', qmp: bool = False):
 
         assert self._pid == self._p.pid
 
-    def qmp(self, cmd: str, args: Optional[Dict[str, object]] = None) \
+    def qmp(self, cmd: str, args: Optional[dict[str, object]] = None) \
             -> QMPMessage:
         assert self._qmp is not None
         return self._qmp.cmd_raw(cmd, args)
@@ -466,7 +476,7 @@ def get_qmp(self) -> QEMUMonitorProtocol:
         assert self._qmp is not None
         return self._qmp
 
-    def cmd(self, cmd: str, args: Optional[Dict[str, object]] = None) \
+    def cmd(self, cmd: str, args: Optional[dict[str, object]] = None) \
             -> QMPReturnValue:
         assert self._qmp is not None
         return self._qmp.cmd(cmd, **(args or {}))
@@ -498,7 +508,7 @@ def qemu_nbd(*args):
     '''Run qemu-nbd in daemon mode and return the parent's exit code'''
     return subprocess.call(qemu_nbd_args + ['--fork'] + list(args))
 
-def qemu_nbd_early_pipe(*args: str) -> Tuple[int, str]:
+def qemu_nbd_early_pipe(*args: str) -> tuple[int, str]:
     '''Run qemu-nbd in daemon mode and return both the parent's exit code
        and its output in case of an error'''
     full_args = qemu_nbd_args + ['--fork'] + list(args)
@@ -716,7 +726,7 @@ def filter_qtest(output: str) -> str:
     output = re.sub(r'\n?\[I \+\d+\.\d+\] CLOSED\n?$', '', output)
     return output
 
-Msg = TypeVar('Msg', Dict[str, Any], List[Any], str)
+Msg = TypeVar('Msg', dict[str, Any], list[Any], str)
 
 def log(msg: Msg,
         filters: Iterable[Callable[[Msg], Msg]] = (),
@@ -753,7 +763,7 @@ def timeout(self, signum, frame):
         raise TimeoutError(self.errmsg)
 
 def file_pattern(name):
-    return "{0}-{1}".format(os.getpid(), name)
+    return f"{os.getpid()}-{name}"
 
 class FilePath:
     """
@@ -929,7 +939,7 @@ def add_paused(self):
 
     def hmp(self, command_line: str, use_log: bool = False) -> QMPMessage:
         cmd = 'human-monitor-command'
-        kwargs: Dict[str, Any] = {'command-line': command_line}
+        kwargs: dict[str, Any] = {'command-line': command_line}
         if use_log:
             return self.qmp_log(cmd, **kwargs)
         else:
@@ -1421,11 +1431,11 @@ def _verify_protocol(supported: Sequence[str] = (),
 
 def _verify_platform(supported: Sequence[str] = (),
                      unsupported: Sequence[str] = ()) -> None:
-    if any((sys.platform.startswith(x) for x in unsupported)):
+    if any(sys.platform.startswith(x) for x in unsupported):
         notrun('not suitable for this OS: %s' % sys.platform)
 
     if supported:
-        if not any((sys.platform.startswith(x) for x in supported)):
+        if not any(sys.platform.startswith(x) for x in supported):
             notrun('not suitable for this OS: %s' % sys.platform)
 
 def _verify_cache_mode(supported_cache_modes: Sequence[str] = ()) -> None:
@@ -1472,7 +1482,7 @@ def verify_quorum():
     if not supports_quorum():
         notrun('quorum support missing')
 
-def has_working_luks() -> Tuple[bool, str]:
+def has_working_luks() -> tuple[bool, str]:
     """
     Check whether our LUKS driver can actually create images
     (this extends to LUKS encryption for qcow2).
@@ -1560,8 +1570,8 @@ def skip_if_unsupported(required_formats=(), read_only=False):
     '''Skip Test Decorator
        Runs the test if all the required formats are whitelisted'''
     def skip_test_decorator(func):
-        def func_wrapper(test_case: QMPTestCase, *args: List[Any],
-                         **kwargs: Dict[str, Any]) -> None:
+        def func_wrapper(test_case: QMPTestCase, *args: list[Any],
+                         **kwargs: dict[str, Any]) -> None:
             if callable(required_formats):
                 fmts = required_formats(test_case)
             else:
@@ -1577,13 +1587,13 @@ def func_wrapper(test_case: QMPTestCase, *args: List[Any],
     return skip_test_decorator
 
 def skip_for_formats(formats: Sequence[str] = ()) \
-    -> Callable[[Callable[[QMPTestCase, List[Any], Dict[str, Any]], None]],
-                Callable[[QMPTestCase, List[Any], Dict[str, Any]], None]]:
+    -> Callable[[Callable[[QMPTestCase, list[Any], dict[str, Any]], None]],
+                Callable[[QMPTestCase, list[Any], dict[str, Any]], None]]:
     '''Skip Test Decorator
        Skips the test for the given formats'''
     def skip_test_decorator(func):
-        def func_wrapper(test_case: QMPTestCase, *args: List[Any],
-                         **kwargs: Dict[str, Any]) -> None:
+        def func_wrapper(test_case: QMPTestCase, *args: list[Any],
+                         **kwargs: dict[str, Any]) -> None:
             if imgfmt in formats:
                 msg = f'{test_case}: Skipped for format {imgfmt}'
                 test_case.case_skip(msg)
@@ -1597,7 +1607,7 @@ def skip_if_user_is_root(func):
        Runs the test only without root permissions'''
     def func_wrapper(*args, **kwargs):
         if os.getuid() == 0:
-            case_notrun('{}: cannot be run as root'.format(args[0]))
+            case_notrun(f'{args[0]}: cannot be run as root')
             return None
         else:
             return func(*args, **kwargs)
@@ -1612,7 +1622,7 @@ def addSkip(self, test, reason):
         # Same as TextTestResult, but print dot instead of "s"
         unittest.TestResult.addSkip(self, test, reason)
         if self.showAll:
-            self.stream.writeln("skipped {0!r}".format(reason))
+            self.stream.writeln(f"skipped {reason!r}")
         elif self.dots:
             self.stream.write(".")
             self.stream.flush()
@@ -1635,7 +1645,7 @@ class ReproducibleTestRunner(unittest.TextTestRunner):
     def __init__(
         self,
         stream: Optional[TextIO] = None,
-        resultclass: Type[unittest.TextTestResult] =
+        resultclass: type[unittest.TextTestResult] =
         ReproducibleTestResult,
         **kwargs: Any
     ) -> None:
@@ -1645,7 +1655,7 @@ def __init__(
                          resultclass=resultclass,
                          **kwargs)
 
-def execute_unittest(argv: List[str], debug: bool = False) -> None:
+def execute_unittest(argv: list[str], debug: bool = False) -> None:
     """Executes unittests within the calling module."""
 
     # Some tests have warnings, especially ResourceWarnings for unclosed
diff --git a/tests/qemu-iotests/linters.py b/tests/qemu-iotests/linters.py
index 9fb3fd14497..b2300a13b24 100644
--- a/tests/qemu-iotests/linters.py
+++ b/tests/qemu-iotests/linters.py
@@ -13,11 +13,12 @@
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
+from collections.abc import Mapping
 import os
 import re
 import subprocess
 import sys
-from typing import List, Mapping, Optional
+from typing import Optional
 
 
 # TODO: Empty this list!
@@ -49,7 +50,7 @@ def is_python_file(filename):
             return False
 
 
-def get_test_files() -> List[str]:
+def get_test_files() -> list[str]:
     named_tests = [f'tests/{entry}' for entry in os.listdir('tests')]
     check_tests = set(os.listdir('.') + named_tests) - set(SKIP_FILES)
     return list(filter(is_python_file, check_tests))
@@ -57,7 +58,7 @@ def get_test_files() -> List[str]:
 
 def run_linter(
         tool: str,
-        args: List[str],
+        args: list[str],
         env: Optional[Mapping[str, str]] = None,
         suppress_output: bool = False,
 ) -> None:
@@ -73,7 +74,7 @@ def run_linter(
         check=True,
         stdout=subprocess.PIPE if suppress_output else None,
         stderr=subprocess.STDOUT if suppress_output else None,
-        universal_newlines=True,
+        text=True,
     )
 
 
diff --git a/tests/qemu-iotests/nbd-fault-injector.py b/tests/qemu-iotests/nbd-fault-injector.py
index 6e11ef89b8b..1b67ceca0c3 100755
--- a/tests/qemu-iotests/nbd-fault-injector.py
+++ b/tests/qemu-iotests/nbd-fault-injector.py
@@ -43,11 +43,12 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or later.
 # See the COPYING file in the top-level directory.
 
-import sys
-import socket
-import struct
 import collections
 import configparser
+import socket
+import struct
+import sys
+
 
 FAKE_DISK_SIZE = 8 * 1024 * 1024 * 1024 # 8 GB
 
@@ -87,7 +88,7 @@ def recvall(sock, bufsize):
         received += len(chunk)
     return b''.join(chunks)
 
-class Rule(object):
+class Rule:
     def __init__(self, name, event, io, when):
         self.name = name
         self.event = event
@@ -101,7 +102,7 @@ def match(self, event, io):
             return False
         return True
 
-class FaultInjectionSocket(object):
+class FaultInjectionSocket:
     def __init__(self, sock, rules):
         self.sock = sock
         self.rules = rules
@@ -226,7 +227,7 @@ def parse_config(config):
 
 def load_rules(filename):
     config = configparser.RawConfigParser()
-    with open(filename, 'rt') as f:
+    with open(filename) as f:
         config.read_file(f, filename)
     return parse_config(config)
 
diff --git a/tests/qemu-iotests/qcow2.py b/tests/qemu-iotests/qcow2.py
index 77ca59cc663..3212fef456f 100755
--- a/tests/qemu-iotests/qcow2.py
+++ b/tests/qemu-iotests/qcow2.py
@@ -20,10 +20,7 @@
 
 import sys
 
-from qcow2_format import (
-    QcowHeader,
-    QcowHeaderExtension
-)
+from qcow2_format import QcowHeader, QcowHeaderExtension
 
 
 is_json = False
diff --git a/tests/qemu-iotests/qcow2_format.py b/tests/qemu-iotests/qcow2_format.py
index 8adc9959e10..ce705a1b214 100644
--- a/tests/qemu-iotests/qcow2_format.py
+++ b/tests/qemu-iotests/qcow2_format.py
@@ -17,9 +17,9 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import struct
-import string
 import json
+import string
+import struct
 
 
 class ComplexEncoder(json.JSONEncoder):
@@ -115,8 +115,8 @@ def __init__(self, fd=None, offset=None, data=None):
             assert fd is None and offset is None
 
         values = struct.unpack(self.fmt, data)
-        self.__dict__ = dict((field[2], values[i])
-                             for i, field in enumerate(self.fields))
+        self.__dict__ = {field[2]: values[i]
+                             for i, field in enumerate(self.fields)}
 
     def dump(self, is_json=False):
         if is_json:
@@ -130,10 +130,10 @@ def dump(self, is_json=False):
             else:
                 value_str = str(f[1](value))
 
-            print('{:<25} {}'.format(f[2], value_str))
+            print(f'{f[2]:<25} {value_str}')
 
     def to_json(self):
-        return dict((f[2], self.__dict__[f[2]]) for f in self.fields)
+        return {f[2]: self.__dict__[f[2]] for f in self.fields}
 
 
 class Qcow2BitmapExt(Qcow2Struct):
@@ -207,7 +207,7 @@ def bitmap_dir_entry_raw_size(self):
 
     def dump(self):
         print(f'{"Bitmap name":<25} {self.name}')
-        super(Qcow2BitmapDirEntry, self).dump()
+        super().dump()
         self.bitmap_table.dump()
 
     def to_json(self):
diff --git a/tests/qemu-iotests/qed.py b/tests/qemu-iotests/qed.py
index d6bec960696..210cb4ccab9 100755
--- a/tests/qemu-iotests/qed.py
+++ b/tests/qemu-iotests/qed.py
@@ -10,10 +10,10 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or later.
 # See the COPYING file in the top-level directory.
 
-import sys
-import struct
 import random
-import optparse
+import struct
+import sys
+
 
 # This can be used as a module
 __all__ = ['QED_F_NEED_CHECK', 'QED']
@@ -35,7 +35,7 @@ def err(msg):
 
 def unpack_header(s):
     fields = struct.unpack(header_fmt, s)
-    return dict((field_names[idx], val) for idx, val in enumerate(fields))
+    return {field_names[idx]: val for idx, val in enumerate(fields)}
 
 def pack_header(header):
     fields = tuple(header[x] for x in field_names)
@@ -47,7 +47,7 @@ def unpack_table_elem(s):
 def pack_table_elem(elem):
     return struct.pack(table_elem_fmt, elem)
 
-class QED(object):
+class QED:
     def __init__(self, f):
         self.f = f
 
diff --git a/tests/qemu-iotests/testenv.py b/tests/qemu-iotests/testenv.py
index 6326e46b7b1..1bee80ed7b5 100644
--- a/tests/qemu-iotests/testenv.py
+++ b/tests/qemu-iotests/testenv.py
@@ -16,21 +16,18 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
+import collections
+from contextlib import AbstractContextManager as ContextManager
+import glob
 import os
-import sys
-import tempfile
 from pathlib import Path
-import shutil
-import collections
 import random
+import shutil
 import subprocess
-import glob
-from typing import List, Dict, Any, Optional
+import sys
+import tempfile
+from typing import Any, Optional
 
-if sys.version_info >= (3, 9):
-    from contextlib import AbstractContextManager as ContextManager
-else:
-    from typing import ContextManager
 
 DEF_GDB_OPTIONS = 'localhost:12345'
 
@@ -40,7 +37,7 @@ def isxfile(path: str) -> bool:
 
 def get_default_machine(qemu_prog: str) -> str:
     outp = subprocess.run([qemu_prog, '-machine', 'help'], check=True,
-                          universal_newlines=True,
+                          text=True,
                           stdout=subprocess.PIPE).stdout
 
     machines = outp.split('\n')
@@ -50,7 +47,7 @@ def get_default_machine(qemu_prog: str) -> str:
         return ''
     default_machine = default_machine.split(' ', 1)[0]
 
-    alias_suf = ' (alias of {})'.format(default_machine)
+    alias_suf = f' (alias of {default_machine})'
     alias = next((m for m in machines if m.endswith(alias_suf)), None)
     if alias is not None:
         default_machine = alias.split(' ', 1)[0]
@@ -81,7 +78,7 @@ class TestEnv(ContextManager['TestEnv']):
                      'IMGKEYSECRET', 'QEMU_DEFAULT_MACHINE', 'MALLOC_PERTURB_',
                      'GDB_OPTIONS', 'PRINT_QEMU']
 
-    def prepare_subprocess(self, args: List[str]) -> Dict[str, str]:
+    def prepare_subprocess(self, args: list[str]) -> dict[str, str]:
         if self.debug:
             args.append('-d')
 
@@ -96,7 +93,7 @@ def prepare_subprocess(self, args: List[str]) -> Dict[str, str]:
         os_env.update(self.get_env())
         return os_env
 
-    def get_env(self) -> Dict[str, str]:
+    def get_env(self) -> dict[str, str]:
         env = {}
         for v in self.env_variables:
             val = getattr(self, v.lower(), None)
diff --git a/tests/qemu-iotests/testrunner.py b/tests/qemu-iotests/testrunner.py
index 2e236c8fa39..37f6b00c60b 100644
--- a/tests/qemu-iotests/testrunner.py
+++ b/tests/qemu-iotests/testrunner.py
@@ -16,25 +16,23 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import os
-from pathlib import Path
+from collections.abc import Sequence
+import contextlib
+from contextlib import AbstractContextManager as ContextManager
 import datetime
-import time
 import difflib
-import subprocess
-import contextlib
 import json
+from multiprocessing import Pool
+import os
+from pathlib import Path
 import shutil
+import subprocess
 import sys
-from multiprocessing import Pool
-from typing import List, Optional, Any, Sequence, Dict
+import time
+from typing import Any, Optional
+
 from testenv import TestEnv
 
-if sys.version_info >= (3, 9):
-    from contextlib import AbstractContextManager as ContextManager
-else:
-    from typing import ContextManager
-
 
 def silent_unlink(path: Path) -> None:
     try:
@@ -43,7 +41,7 @@ def silent_unlink(path: Path) -> None:
         pass
 
 
-def file_diff(file1: str, file2: str) -> List[str]:
+def file_diff(file1: str, file2: str) -> list[str]:
     with open(file1, encoding="utf-8") as f1, \
          open(file2, encoding="utf-8") as f2:
         # We want to ignore spaces at line ends. There are a lot of mess about
@@ -66,7 +64,7 @@ class LastElapsedTime(ContextManager['LastElapsedTime']):
     def __init__(self, cache_file: str, env: TestEnv) -> None:
         self.env = env
         self.cache_file = cache_file
-        self.cache: Dict[str, Dict[str, Dict[str, float]]]
+        self.cache: dict[str, dict[str, dict[str, float]]]
 
         try:
             with open(cache_file, encoding="utf-8") as f:
@@ -122,8 +120,8 @@ def proc_run_test(test: str, test_field_width: int) -> TestResult:
         assert runner is not None
         return runner.run_test(test, test_field_width, mp=True)
 
-    def run_tests_pool(self, tests: List[str],
-                       test_field_width: int, jobs: int) -> List[TestResult]:
+    def run_tests_pool(self, tests: list[str],
+                       test_field_width: int, jobs: int) -> list[TestResult]:
 
         # passing self directly to Pool.starmap() just doesn't work, because
         # it's a context manager.
@@ -369,7 +367,7 @@ def run_test(self, test: str,
         sys.stdout.flush()
         return res
 
-    def run_tests(self, tests: List[str], jobs: int = 1) -> bool:
+    def run_tests(self, tests: list[str], jobs: int = 1) -> bool:
         n_run = 0
         failed = []
         notrun = []
diff --git a/tests/qemu-iotests/tests/block-status-cache b/tests/qemu-iotests/tests/block-status-cache
index 5a7bc2c1493..7fc94be4aa4 100755
--- a/tests/qemu-iotests/tests/block-status-cache
+++ b/tests/qemu-iotests/tests/block-status-cache
@@ -21,6 +21,7 @@
 
 import os
 import signal
+
 import iotests
 from iotests import qemu_img_create, qemu_img_map, qemu_nbd
 
diff --git a/tests/qemu-iotests/tests/export-incoming-iothread b/tests/qemu-iotests/tests/export-incoming-iothread
index d36d6194e0a..4e5825d081f 100755
--- a/tests/qemu-iotests/tests/export-incoming-iothread
+++ b/tests/qemu-iotests/tests/export-incoming-iothread
@@ -23,6 +23,7 @@
 #
 
 import os
+
 import iotests
 from iotests import qemu_img_create
 
diff --git a/tests/qemu-iotests/tests/graph-changes-while-io b/tests/qemu-iotests/tests/graph-changes-while-io
index dca1167b6d1..0bf7da2b83b 100755
--- a/tests/qemu-iotests/tests/graph-changes-while-io
+++ b/tests/qemu-iotests/tests/graph-changes-while-io
@@ -21,9 +21,16 @@
 
 import os
 from threading import Thread
+
 import iotests
-from iotests import imgfmt, qemu_img, qemu_img_create, qemu_io, \
-        QMPTestCase, QemuStorageDaemon
+from iotests import (
+    QemuStorageDaemon,
+    QMPTestCase,
+    imgfmt,
+    qemu_img,
+    qemu_img_create,
+    qemu_io,
+)
 
 
 top = os.path.join(iotests.test_dir, 'top.img')
diff --git a/tests/qemu-iotests/tests/image-fleecing b/tests/qemu-iotests/tests/image-fleecing
index 5e3b2c7e46a..fd245568fb8 100755
--- a/tests/qemu-iotests/tests/image-fleecing
+++ b/tests/qemu-iotests/tests/image-fleecing
@@ -27,6 +27,7 @@ from subprocess import CalledProcessError
 import iotests
 from iotests import log, qemu_img, qemu_io
 
+
 iotests.script_initialize(
     supported_fmts=['qcow2'],
     supported_platforms=['linux'],
diff --git a/tests/qemu-iotests/tests/inactive-node-nbd b/tests/qemu-iotests/tests/inactive-node-nbd
index a95b37e7962..03f266bb4ca 100755
--- a/tests/qemu-iotests/tests/inactive-node-nbd
+++ b/tests/qemu-iotests/tests/inactive-node-nbd
@@ -19,9 +19,13 @@
 # Creator/Owner: Kevin Wolf <kwolf@redhat.com>
 
 import iotests
+from iotests import (
+    QemuIoInteractive,
+    filter_qemu_io,
+    filter_qmp_testfiles,
+    filter_qtest,
+)
 
-from iotests import QemuIoInteractive
-from iotests import filter_qemu_io, filter_qtest, filter_qmp_testfiles
 
 iotests.script_initialize(supported_fmts=['generic'],
                           supported_protocols=['file'],
diff --git a/tests/qemu-iotests/tests/iothreads-commit-active b/tests/qemu-iotests/tests/iothreads-commit-active
index 4010a4871f2..b9629fa855c 100755
--- a/tests/qemu-iotests/tests/iothreads-commit-active
+++ b/tests/qemu-iotests/tests/iothreads-commit-active
@@ -19,8 +19,10 @@
 # Creator/Owner: Kevin Wolf <kwolf@redhat.com>
 
 import asyncio
+
 import iotests
 
+
 iotests.script_initialize(supported_fmts=['qcow2'],
                           supported_platforms=['linux'])
 iotests.verify_virtio_scsi_pci_or_ccw()
diff --git a/tests/qemu-iotests/tests/iothreads-create b/tests/qemu-iotests/tests/iothreads-create
index 0c862d73f20..e0a8e32c7f2 100755
--- a/tests/qemu-iotests/tests/iothreads-create
+++ b/tests/qemu-iotests/tests/iothreads-create
@@ -19,8 +19,10 @@
 # Creator/Owner: Kevin Wolf <kwolf@redhat.com>
 
 import asyncio
+
 import iotests
 
+
 iotests.script_initialize(supported_fmts=['qcow2', 'qcow', 'qed', 'vdi',
                                           'vmdk', 'parallels'])
 iotests.verify_virtio_scsi_pci_or_ccw()
diff --git a/tests/qemu-iotests/tests/iothreads-nbd-export b/tests/qemu-iotests/tests/iothreads-nbd-export
index 037260729c7..bc86798966a 100755
--- a/tests/qemu-iotests/tests/iothreads-nbd-export
+++ b/tests/qemu-iotests/tests/iothreads-nbd-export
@@ -19,9 +19,12 @@
 # Creator/Owner: Kevin Wolf <kwolf@redhat.com>
 
 import time
+
 import qemu
+
 import iotests
 
+
 iotests.script_initialize(supported_fmts=['qcow2'],
                           supported_platforms=['linux'])
 
diff --git a/tests/qemu-iotests/tests/iothreads-stream b/tests/qemu-iotests/tests/iothreads-stream
index 231195b5e87..72e5689f156 100755
--- a/tests/qemu-iotests/tests/iothreads-stream
+++ b/tests/qemu-iotests/tests/iothreads-stream
@@ -19,8 +19,10 @@
 # Creator/Owner: Kevin Wolf <kwolf@redhat.com>
 
 import asyncio
+
 import iotests
 
+
 iotests.script_initialize(supported_fmts=['qcow2'],
                           supported_platforms=['linux'])
 iotests.verify_virtio_scsi_pci_or_ccw()
diff --git a/tests/qemu-iotests/tests/luks-detached-header b/tests/qemu-iotests/tests/luks-detached-header
index 3455fd8de1e..6c6d992d153 100755
--- a/tests/qemu-iotests/tests/luks-detached-header
+++ b/tests/qemu-iotests/tests/luks-detached-header
@@ -22,14 +22,15 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 
-import os
 import json
+import os
+
 import iotests
 from iotests import (
+    QMPTestCase,
     imgfmt,
     qemu_img_create,
     qemu_img_info,
-    QMPTestCase,
 )
 
 
diff --git a/tests/qemu-iotests/tests/migrate-bitmaps-postcopy-test b/tests/qemu-iotests/tests/migrate-bitmaps-postcopy-test
index c519e6db8c7..ee477244fe7 100755
--- a/tests/qemu-iotests/tests/migrate-bitmaps-postcopy-test
+++ b/tests/qemu-iotests/tests/migrate-bitmaps-postcopy-test
@@ -20,9 +20,11 @@
 #
 
 import os
+
 import iotests
 from iotests import qemu_img
 
+
 debug = False
 
 disk_a = os.path.join(iotests.test_dir, 'disk_a')
@@ -119,7 +121,7 @@ class TestDirtyBitmapPostcopyMigration(iotests.QMPTestCase):
         """ Run migration until RESUME event on target. Return this event. """
         for i in range(nb_bitmaps):
             self.vm_a.cmd('block-dirty-bitmap-add', node='drive0',
-                          name='bitmap{}'.format(i),
+                          name=f'bitmap{i}',
                           granularity=granularity,
                           persistent=True)
 
@@ -140,7 +142,7 @@ class TestDirtyBitmapPostcopyMigration(iotests.QMPTestCase):
         # other bitmaps
         for i in range(1, nb_bitmaps):
             self.vm_a.cmd('block-dirty-bitmap-disable', node='drive0',
-                          name='bitmap{}'.format(i))
+                          name=f'bitmap{i}')
 
         apply_discards(self.vm_a, discards2)
 
@@ -151,7 +153,7 @@ class TestDirtyBitmapPostcopyMigration(iotests.QMPTestCase):
         # Now, enable some bitmaps, to be updated during migration
         for i in range(2, nb_bitmaps, 2):
             self.vm_a.cmd('block-dirty-bitmap-enable', node='drive0',
-                          name='bitmap{}'.format(i))
+                          name=f'bitmap{i}')
 
         caps = [{'capability': 'dirty-bitmaps', 'state': True},
                 {'capability': 'events', 'state': True}]
@@ -210,7 +212,7 @@ class TestDirtyBitmapPostcopyMigration(iotests.QMPTestCase):
         # every bitmap
         for i in range(0, nb_bitmaps, 5):
             result = self.vm_b.qmp('x-debug-block-dirty-bitmap-sha256',
-                                   node='drive0', name='bitmap{}'.format(i))
+                                   node='drive0', name=f'bitmap{i}')
             sha = discards1_sha256 if i % 2 else all_discards_sha256
             self.assert_qmp(result, 'return/sha256', sha)
 
diff --git a/tests/qemu-iotests/tests/migrate-bitmaps-test b/tests/qemu-iotests/tests/migrate-bitmaps-test
index 8fb4099201d..b577e59416c 100755
--- a/tests/qemu-iotests/tests/migrate-bitmaps-test
+++ b/tests/qemu-iotests/tests/migrate-bitmaps-test
@@ -25,7 +25,7 @@ import os
 import re
 
 import iotests
-from iotests import qemu_img, qemu_img_create, Timeout
+from iotests import Timeout, qemu_img, qemu_img_create
 
 
 disk_a = os.path.join(iotests.test_dir, 'disk_a')
diff --git a/tests/qemu-iotests/tests/migrate-during-backup b/tests/qemu-iotests/tests/migrate-during-backup
index afb2277896a..d23a3d0bc14 100755
--- a/tests/qemu-iotests/tests/migrate-during-backup
+++ b/tests/qemu-iotests/tests/migrate-during-backup
@@ -18,6 +18,7 @@
 #
 
 import os
+
 import iotests
 from iotests import qemu_img_create, qemu_io
 
diff --git a/tests/qemu-iotests/tests/mirror-change-copy-mode b/tests/qemu-iotests/tests/mirror-change-copy-mode
index 51788b85c7a..b4e5965bbe0 100755
--- a/tests/qemu-iotests/tests/mirror-change-copy-mode
+++ b/tests/qemu-iotests/tests/mirror-change-copy-mode
@@ -23,7 +23,8 @@ import os
 import time
 
 import iotests
-from iotests import qemu_img, QemuStorageDaemon
+from iotests import QemuStorageDaemon, qemu_img
+
 
 iops_target = 8
 iops_source = iops_target * 2
diff --git a/tests/qemu-iotests/tests/mirror-ready-cancel-error b/tests/qemu-iotests/tests/mirror-ready-cancel-error
index ed2e46447e3..2f1e50cb039 100755
--- a/tests/qemu-iotests/tests/mirror-ready-cancel-error
+++ b/tests/qemu-iotests/tests/mirror-ready-cancel-error
@@ -21,6 +21,7 @@
 #
 
 import os
+
 import iotests
 
 
diff --git a/tests/qemu-iotests/tests/nbd-multiconn b/tests/qemu-iotests/tests/nbd-multiconn
index 479e872f2a8..33be233833e 100755
--- a/tests/qemu-iotests/tests/nbd-multiconn
+++ b/tests/qemu-iotests/tests/nbd-multiconn
@@ -18,8 +18,8 @@
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
-import os
 from contextlib import contextmanager
+import os
 from types import ModuleType
 
 import iotests
diff --git a/tests/qemu-iotests/tests/nbd-reconnect-on-open b/tests/qemu-iotests/tests/nbd-reconnect-on-open
index 3ce52021c37..912012f61e3 100755
--- a/tests/qemu-iotests/tests/nbd-reconnect-on-open
+++ b/tests/qemu-iotests/tests/nbd-reconnect-on-open
@@ -21,8 +21,15 @@
 import time
 
 import iotests
-from iotests import qemu_img_create, file_path, qemu_io_popen, qemu_nbd, \
-    qemu_io_log, log
+from iotests import (
+    file_path,
+    log,
+    qemu_img_create,
+    qemu_io_log,
+    qemu_io_popen,
+    qemu_nbd,
+)
+
 
 iotests.script_initialize(supported_fmts=['qcow2'])
 
diff --git a/tests/qemu-iotests/tests/parallels-read-bitmap b/tests/qemu-iotests/tests/parallels-read-bitmap
index 38ab5fa5b28..34e15fead36 100755
--- a/tests/qemu-iotests/tests/parallels-read-bitmap
+++ b/tests/qemu-iotests/tests/parallels-read-bitmap
@@ -19,7 +19,13 @@
 #
 
 import iotests
-from iotests import qemu_nbd_popen, qemu_img_map, log, file_path
+from iotests import (
+    file_path,
+    log,
+    qemu_img_map,
+    qemu_nbd_popen,
+)
+
 
 iotests.script_initialize(supported_fmts=['parallels'])
 
diff --git a/tests/qemu-iotests/tests/qsd-migrate b/tests/qemu-iotests/tests/qsd-migrate
index a4c6592420c..cff0b486b19 100755
--- a/tests/qemu-iotests/tests/qsd-migrate
+++ b/tests/qemu-iotests/tests/qsd-migrate
@@ -19,9 +19,9 @@
 # Creator/Owner: Kevin Wolf <kwolf@redhat.com>
 
 import iotests
-
 from iotests import filter_qemu_io, filter_qtest
 
+
 iotests.script_initialize(supported_fmts=['qcow2', 'qed', 'raw'],
                           supported_protocols=['file'],
                           supported_platforms=['linux'])
diff --git a/tests/qemu-iotests/tests/remove-bitmap-from-backing b/tests/qemu-iotests/tests/remove-bitmap-from-backing
index 15be32dcb96..5816fb1ed60 100755
--- a/tests/qemu-iotests/tests/remove-bitmap-from-backing
+++ b/tests/qemu-iotests/tests/remove-bitmap-from-backing
@@ -19,7 +19,13 @@
 #
 
 import iotests
-from iotests import log, qemu_img_create, qemu_img, qemu_img_info
+from iotests import (
+    log,
+    qemu_img,
+    qemu_img_create,
+    qemu_img_info,
+)
+
 
 iotests.script_initialize(supported_fmts=['qcow2'],
                           unsupported_imgopts=['compat'])
diff --git a/tests/qemu-iotests/tests/reopen-file b/tests/qemu-iotests/tests/reopen-file
index 5a50794ffc4..67ce592ae67 100755
--- a/tests/qemu-iotests/tests/reopen-file
+++ b/tests/qemu-iotests/tests/reopen-file
@@ -20,8 +20,9 @@
 #
 
 import os
+
 import iotests
-from iotests import imgfmt, qemu_img_create, QMPTestCase
+from iotests import QMPTestCase, imgfmt, qemu_img_create
 
 
 image_size = 1 * 1024 * 1024
diff --git a/tests/qemu-iotests/tests/stream-error-on-reset b/tests/qemu-iotests/tests/stream-error-on-reset
index b60aabb68ea..b29e542c8a0 100755
--- a/tests/qemu-iotests/tests/stream-error-on-reset
+++ b/tests/qemu-iotests/tests/stream-error-on-reset
@@ -20,8 +20,14 @@
 #
 
 import os
+
 import iotests
-from iotests import imgfmt, qemu_img_create, qemu_io, QMPTestCase
+from iotests import (
+    QMPTestCase,
+    imgfmt,
+    qemu_img_create,
+    qemu_io,
+)
 
 
 image_size = 1 * 1024 * 1024
diff --git a/tests/qemu-iotests/tests/stream-unaligned-prefetch b/tests/qemu-iotests/tests/stream-unaligned-prefetch
index 546db1d3698..fecd43cc999 100755
--- a/tests/qemu-iotests/tests/stream-unaligned-prefetch
+++ b/tests/qemu-iotests/tests/stream-unaligned-prefetch
@@ -21,8 +21,15 @@
 #
 
 import os
+
 import iotests
-from iotests import imgfmt, qemu_img_create, qemu_io, QMPTestCase
+from iotests import (
+    QMPTestCase,
+    imgfmt,
+    qemu_img_create,
+    qemu_io,
+)
+
 
 image_size = 1 * 1024 * 1024
 cluster_size = 64 * 1024
@@ -42,11 +49,11 @@ class TestStreamUnalignedPrefetch(QMPTestCase):
         size.
         """
         qemu_img_create('-f', imgfmt,
-                        '-o', 'cluster_size={}'.format(cluster_size // 2),
+                        '-o', f'cluster_size={cluster_size // 2}',
                         base, str(image_size))
         qemu_io('-c', f'write 0 {cluster_size // 2}', base)
         qemu_img_create('-f', imgfmt,
-                        '-o', 'cluster_size={}'.format(cluster_size),
+                        '-o', f'cluster_size={cluster_size}',
                         top, str(image_size))
 
         self.vm = iotests.VM()
diff --git a/tests/qemu-iotests/tests/stream-under-throttle b/tests/qemu-iotests/tests/stream-under-throttle
index 1a50b682fc4..543af9d2ab6 100755
--- a/tests/qemu-iotests/tests/stream-under-throttle
+++ b/tests/qemu-iotests/tests/stream-under-throttle
@@ -21,7 +21,7 @@
 
 import asyncio
 import os
-from typing import List
+
 import iotests
 from iotests import qemu_img_create, qemu_io
 
@@ -39,7 +39,7 @@ class TcgVM(iotests.VM):
     the order they appear.
     '''
     @property
-    def _base_args(self) -> List[str]:
+    def _base_args(self) -> list[str]:
         # Put -accel tcg first so it takes precedence
         return ['-accel', 'tcg'] + super()._base_args
 
diff --git a/tests/qemu-iotests/tests/vvfat b/tests/qemu-iotests/tests/vvfat
index acdc6ce8fff..06da0b4fcf8 100755
--- a/tests/qemu-iotests/tests/vvfat
+++ b/tests/qemu-iotests/tests/vvfat
@@ -22,9 +22,12 @@
 
 import os
 import shutil
+
+from fat16 import DIRENTRY_SIZE, MBR, Fat16
+
 import iotests
-from iotests import imgfmt, QMPTestCase
-from fat16 import MBR, Fat16, DIRENTRY_SIZE
+from iotests import QMPTestCase, imgfmt
+
 
 filesystem = os.path.join(iotests.test_dir, "filesystem")
 
diff --git a/tests/tcg/aarch64/gdbstub/test-mte.py b/tests/tcg/aarch64/gdbstub/test-mte.py
index 9ad98e7a54c..6ba39319c6e 100644
--- a/tests/tcg/aarch64/gdbstub/test-mte.py
+++ b/tests/tcg/aarch64/gdbstub/test-mte.py
@@ -1,4 +1,3 @@
-from __future__ import print_function
 #
 # Test GDB memory-tag commands that exercise the stubs for the qIsAddressTagged,
 # qMemTag, and QMemTag packets, which are used for manipulating allocation tags.
@@ -20,6 +19,7 @@
     exit("This script must be launched via tests/guest-debug/run-test.py!")
 import re
 from sys import argv
+
 from test_gdbstub import arg_parser, main, report
 
 
diff --git a/tests/tcg/aarch64/gdbstub/test-sve-ioctl.py b/tests/tcg/aarch64/gdbstub/test-sve-ioctl.py
index a78a3a2514d..a84aca622ff 100644
--- a/tests/tcg/aarch64/gdbstub/test-sve-ioctl.py
+++ b/tests/tcg/aarch64/gdbstub/test-sve-ioctl.py
@@ -1,4 +1,3 @@
-from __future__ import print_function
 #
 # Test the SVE ZReg reports the right amount of data. It uses the
 # sve-ioctl test and examines the register data each time the
@@ -10,12 +9,13 @@
 import gdb
 from test_gdbstub import main, report
 
+
 initial_vlen = 0
 
 
 class TestBreakpoint(gdb.Breakpoint):
     def __init__(self, sym_name="__sve_ld_done"):
-        super(TestBreakpoint, self).__init__(sym_name)
+        super().__init__(sym_name)
         # self.sym, ok = gdb.lookup_symbol(sym_name)
 
     def stop(self):
diff --git a/tests/tcg/aarch64/gdbstub/test-sve.py b/tests/tcg/aarch64/gdbstub/test-sve.py
index 84cdcd4a32e..dee3032a202 100644
--- a/tests/tcg/aarch64/gdbstub/test-sve.py
+++ b/tests/tcg/aarch64/gdbstub/test-sve.py
@@ -1,4 +1,3 @@
-from __future__ import print_function
 #
 # Test the SVE registers are visible and changeable via gdbstub
 #
@@ -8,6 +7,7 @@
 import gdb
 from test_gdbstub import main, report
 
+
 MAGIC = 0xDEADBEEF
 
 
diff --git a/tests/tcg/i386/test-avx.py b/tests/tcg/i386/test-avx.py
index 6063fb2d11d..1c37af4f780 100755
--- a/tests/tcg/i386/test-avx.py
+++ b/tests/tcg/i386/test-avx.py
@@ -3,8 +3,9 @@
 # Generate test-avx.h from x86.csv
 
 import csv
-import sys
 from fnmatch import fnmatch
+import sys
+
 
 archs = [
     "SSE", "SSE2", "SSE3", "SSSE3", "SSE4_1", "SSE4_2",
@@ -12,8 +13,8 @@
     "F16C", "FMA", "SHA",
 ]
 
-ignore = set(["FISTTP",
-    "LDMXCSR", "VLDMXCSR", "STMXCSR", "VSTMXCSR"])
+ignore = {"FISTTP",
+    "LDMXCSR", "VLDMXCSR", "STMXCSR", "VSTMXCSR"}
 
 imask = {
     'vBLENDPD': 0xff,
@@ -236,7 +237,7 @@ def __init__(self, op, args):
 
         try:
             self.args = list(ArgGenerator(a, op) for a in args)
-            if not any((x.isxmm for x in self.args)):
+            if not any(x.isxmm for x in self.args):
                 raise SkipInstruction
             if len(self.args) > 0 and self.args[-1] is None:
                 self.args = self.args[:-1]
@@ -353,7 +354,7 @@ def main():
     if len(sys.argv) != 3:
         print("Usage: test-avx.py x86.csv test-avx.h")
         exit(1)
-    csvfile = open(sys.argv[1], 'r', newline='')
+    csvfile = open(sys.argv[1], newline='')
     with open(sys.argv[2], "w") as outf:
         outf.write("// Generated by test-avx.py. Do not edit.\n")
         for row in csv.reader(strip_comments(csvfile)):
diff --git a/tests/tcg/i386/test-mmx.py b/tests/tcg/i386/test-mmx.py
index 392315e1769..df105088c70 100755
--- a/tests/tcg/i386/test-mmx.py
+++ b/tests/tcg/i386/test-mmx.py
@@ -3,11 +3,12 @@
 # Generate test-avx.h from x86.csv
 
 import csv
-import sys
 from fnmatch import fnmatch
+import sys
 
-ignore = set(["EMMS", "FEMMS", "FISTTP",
-    "LDMXCSR", "VLDMXCSR", "STMXCSR", "VSTMXCSR"])
+
+ignore = {"EMMS", "FEMMS", "FISTTP",
+    "LDMXCSR", "VLDMXCSR", "STMXCSR", "VSTMXCSR"}
 
 imask = {
     'PALIGNR': 0x3f,
@@ -220,7 +221,7 @@ def main():
     if len(sys.argv) <= 3:
         print("Usage: test-mmx.py x86.csv test-mmx.h CPUID...")
         exit(1)
-    csvfile = open(sys.argv[1], 'r', newline='')
+    csvfile = open(sys.argv[1], newline='')
     archs = sys.argv[3:]
     with open(sys.argv[2], "w") as outf:
         outf.write("// Generated by test-mmx.py. Do not edit.\n")
diff --git a/tests/tcg/multiarch/gdbstub/catch-syscalls.py b/tests/tcg/multiarch/gdbstub/catch-syscalls.py
index ccce35902fb..d54ea75909d 100644
--- a/tests/tcg/multiarch/gdbstub/catch-syscalls.py
+++ b/tests/tcg/multiarch/gdbstub/catch-syscalls.py
@@ -8,7 +8,7 @@
 def check_state(expected):
     """Check the catch_syscalls_state value"""
     actual = gdb.parse_and_eval("catch_syscalls_state").string()
-    report(actual == expected, "{} == {}".format(actual, expected))
+    report(actual == expected, f"{actual} == {expected}")
 
 
 def run_test():
@@ -23,7 +23,7 @@ def run_test():
     except gdb.error as exc:
         exc_str = str(exc)
         if "not supported on this architecture" in exc_str:
-            print("SKIP: {}".format(exc_str))
+            print(f"SKIP: {exc_str}")
             return
         raise
     for _ in range(2):
@@ -47,7 +47,7 @@ def run_test():
     gdb.execute("continue")
 
     exitcode = int(gdb.parse_and_eval("$_exitcode"))
-    report(exitcode == 0, "{} == 0".format(exitcode))
+    report(exitcode == 0, f"{exitcode} == 0")
 
 
 main(run_test)
diff --git a/tests/tcg/multiarch/gdbstub/follow-fork-mode-child.py b/tests/tcg/multiarch/gdbstub/follow-fork-mode-child.py
index 72a6e440c08..b0cac994a9e 100644
--- a/tests/tcg/multiarch/gdbstub/follow-fork-mode-child.py
+++ b/tests/tcg/multiarch/gdbstub/follow-fork-mode-child.py
@@ -15,7 +15,7 @@ def run_test():
     have_fork_syscall = False
     for fork_syscall in ("fork", "clone", "clone2", "clone3"):
         try:
-            gdb.execute("catch syscall {}".format(fork_syscall))
+            gdb.execute(f"catch syscall {fork_syscall}")
         except gdb.error:
             pass
         else:
@@ -34,7 +34,7 @@ def run_test():
         # break_after_fork()
         gdb.execute("continue")
     exitcode = int(gdb.parse_and_eval("$_exitcode"))
-    report(exitcode == 42, "{} == 42".format(exitcode))
+    report(exitcode == 42, f"{exitcode} == 42")
 
 
 main(run_test)
diff --git a/tests/tcg/multiarch/gdbstub/follow-fork-mode-parent.py b/tests/tcg/multiarch/gdbstub/follow-fork-mode-parent.py
index 5c2fe722088..be7d6a72919 100644
--- a/tests/tcg/multiarch/gdbstub/follow-fork-mode-parent.py
+++ b/tests/tcg/multiarch/gdbstub/follow-fork-mode-parent.py
@@ -10,7 +10,7 @@ def run_test():
     gdb.execute("set follow-fork-mode parent")
     gdb.execute("continue")
     exitcode = int(gdb.parse_and_eval("$_exitcode"))
-    report(exitcode == 0, "{} == 0".format(exitcode))
+    report(exitcode == 0, f"{exitcode} == 0")
 
 
 main(run_test)
diff --git a/tests/tcg/multiarch/gdbstub/interrupt.py b/tests/tcg/multiarch/gdbstub/interrupt.py
index 2d5654d1540..4eccdb41b97 100644
--- a/tests/tcg/multiarch/gdbstub/interrupt.py
+++ b/tests/tcg/multiarch/gdbstub/interrupt.py
@@ -1,4 +1,3 @@
-from __future__ import print_function
 #
 # Test some of the system debug features with the multiarch memory
 # test. It is a port of the original vmlinux focused test case but
diff --git a/tests/tcg/multiarch/gdbstub/late-attach.py b/tests/tcg/multiarch/gdbstub/late-attach.py
index 1d40efb5ec8..bf3deeb853c 100644
--- a/tests/tcg/multiarch/gdbstub/late-attach.py
+++ b/tests/tcg/multiarch/gdbstub/late-attach.py
@@ -17,12 +17,12 @@ def run_test():
         gdb.execute("break sigwait")
         gdb.execute("continue")
         phase = gdb.parse_and_eval("phase").string()
-    report(phase == "sigwait", "{} == \"sigwait\"".format(phase))
+    report(phase == "sigwait", f"{phase} == \"sigwait\"")
 
     gdb.execute("signal SIGUSR1")
 
     exitcode = int(gdb.parse_and_eval("$_exitcode"))
-    report(exitcode == 0, "{} == 0".format(exitcode))
+    report(exitcode == 0, f"{exitcode} == 0")
 
 
 main(run_test)
diff --git a/tests/tcg/multiarch/gdbstub/memory.py b/tests/tcg/multiarch/gdbstub/memory.py
index 532b92e7fb3..dbdb22585db 100644
--- a/tests/tcg/multiarch/gdbstub/memory.py
+++ b/tests/tcg/multiarch/gdbstub/memory.py
@@ -1,4 +1,3 @@
-from __future__ import print_function
 #
 # Test some of the system debug features with the multiarch memory
 # test. It is a port of the original vmlinux focused test case but
@@ -8,7 +7,6 @@
 #
 
 import gdb
-import sys
 from test_gdbstub import main, report
 
 
diff --git a/tests/tcg/multiarch/gdbstub/prot-none.py b/tests/tcg/multiarch/gdbstub/prot-none.py
index 51082a30e40..a76f496c455 100644
--- a/tests/tcg/multiarch/gdbstub/prot-none.py
+++ b/tests/tcg/multiarch/gdbstub/prot-none.py
@@ -5,6 +5,7 @@
 SPDX-License-Identifier: GPL-2.0-or-later
 """
 import ctypes
+
 from test_gdbstub import gdb_exit, main, report
 
 
@@ -26,11 +27,11 @@ def run_test():
     gdb.Breakpoint("break_here")
     gdb.execute("continue")
     val = gdb.parse_and_eval("*(char[2] *)q").string()
-    report(val == "42", "{} == 42".format(val))
+    report(val == "42", f"{val} == 42")
     gdb.execute("set *(char[3] *)q = \"24\"")
     gdb.execute("continue")
     exitcode = int(gdb.parse_and_eval("$_exitcode"))
-    report(exitcode == 0, "{} == 0".format(exitcode))
+    report(exitcode == 0, f"{exitcode} == 0")
 
 
 main(run_test)
diff --git a/tests/tcg/multiarch/gdbstub/registers.py b/tests/tcg/multiarch/gdbstub/registers.py
index b3d13cb077f..3b79643cbc1 100644
--- a/tests/tcg/multiarch/gdbstub/registers.py
+++ b/tests/tcg/multiarch/gdbstub/registers.py
@@ -6,8 +6,9 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-import gdb
 import xml.etree.ElementTree as ET
+
+import gdb
 from test_gdbstub import main, report
 
 
diff --git a/tests/tcg/multiarch/gdbstub/sha1.py b/tests/tcg/multiarch/gdbstub/sha1.py
index 1ce711a402c..3403b82fd4a 100644
--- a/tests/tcg/multiarch/gdbstub/sha1.py
+++ b/tests/tcg/multiarch/gdbstub/sha1.py
@@ -1,4 +1,3 @@
-from __future__ import print_function
 #
 # A very simple smoke test for debugging the SHA1 userspace test on
 # each target.
diff --git a/tests/tcg/multiarch/gdbstub/test-proc-mappings.py b/tests/tcg/multiarch/gdbstub/test-proc-mappings.py
index 6eb6ebf7b17..796dca75f0c 100644
--- a/tests/tcg/multiarch/gdbstub/test-proc-mappings.py
+++ b/tests/tcg/multiarch/gdbstub/test-proc-mappings.py
@@ -1,7 +1,6 @@
 """Test that gdbstub has access to proc mappings.
 
 This runs as a sourced script (via -x, via run-test.py)."""
-from __future__ import print_function
 import gdb
 from test_gdbstub import gdb_exit, main, report
 
diff --git a/tests/tcg/multiarch/gdbstub/test-qxfer-auxv-read.py b/tests/tcg/multiarch/gdbstub/test-qxfer-auxv-read.py
index 00c26ab4a95..fa36c943d66 100644
--- a/tests/tcg/multiarch/gdbstub/test-qxfer-auxv-read.py
+++ b/tests/tcg/multiarch/gdbstub/test-qxfer-auxv-read.py
@@ -1,4 +1,3 @@
-from __future__ import print_function
 #
 # Test auxiliary vector is loaded via gdbstub
 #
diff --git a/tests/tcg/multiarch/gdbstub/test-qxfer-siginfo-read.py b/tests/tcg/multiarch/gdbstub/test-qxfer-siginfo-read.py
index 862596b07a7..a17b83458b1 100644
--- a/tests/tcg/multiarch/gdbstub/test-qxfer-siginfo-read.py
+++ b/tests/tcg/multiarch/gdbstub/test-qxfer-siginfo-read.py
@@ -1,4 +1,3 @@
-from __future__ import print_function
 #
 # Test gdbstub Xfer:siginfo:read stub.
 #
@@ -16,6 +15,7 @@
 import gdb
 from test_gdbstub import main, report
 
+
 def run_test():
     "Run through the test"
 
diff --git a/tests/tcg/multiarch/gdbstub/test-thread-breakpoint.py b/tests/tcg/multiarch/gdbstub/test-thread-breakpoint.py
index 4d6b6b9fbe7..49cbc3548f6 100644
--- a/tests/tcg/multiarch/gdbstub/test-thread-breakpoint.py
+++ b/tests/tcg/multiarch/gdbstub/test-thread-breakpoint.py
@@ -1,4 +1,3 @@
-from __future__ import print_function
 #
 # Test auxiliary vector is loaded via gdbstub
 #
diff --git a/tests/tcg/multiarch/system/validate-memory-counts.py b/tests/tcg/multiarch/system/validate-memory-counts.py
index 5b8bbf3ef37..01f4a3a25b6 100755
--- a/tests/tcg/multiarch/system/validate-memory-counts.py
+++ b/tests/tcg/multiarch/system/validate-memory-counts.py
@@ -10,8 +10,9 @@
 #
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-import sys
 from argparse import ArgumentParser
+import sys
+
 
 def extract_counts(path):
     """
@@ -29,7 +30,7 @@ def extract_counts(path):
     end_address = None
     read_count = 0
     write_count = 0
-    with open(path, 'r') as f:
+    with open(path) as f:
         for line in f:
             if line.startswith("Test data start:"):
                 start_address = int(line.split(':')[1].strip(), 16)
@@ -59,7 +60,7 @@ def parse_plugin_output(path, start, end):
     total_writes = 0
     seen_all = False
 
-    with open(path, 'r') as f:
+    with open(path) as f:
         next(f)  # Skip the header
         for line in f:
 
diff --git a/tests/tcg/s390x/gdbstub/test-signals-s390x.py b/tests/tcg/s390x/gdbstub/test-signals-s390x.py
index b6b7b39fc46..367caa0bfd9 100644
--- a/tests/tcg/s390x/gdbstub/test-signals-s390x.py
+++ b/tests/tcg/s390x/gdbstub/test-signals-s390x.py
@@ -1,5 +1,3 @@
-from __future__ import print_function
-
 #
 # Test that signals and debugging mix well together on s390x.
 #
diff --git a/tests/tcg/s390x/gdbstub/test-svc.py b/tests/tcg/s390x/gdbstub/test-svc.py
index 17210b4e020..29a0aa0ede4 100644
--- a/tests/tcg/s390x/gdbstub/test-svc.py
+++ b/tests/tcg/s390x/gdbstub/test-svc.py
@@ -1,7 +1,6 @@
 """Test single-stepping SVC.
 
 This runs as a sourced script (via -x, via run-test.py)."""
-from __future__ import print_function
 import gdb
 from test_gdbstub import main, report
 
diff --git a/tests/vm/aarch64vm.py b/tests/vm/aarch64vm.py
index b00cce07eb8..7c459c827e3 100644
--- a/tests/vm/aarch64vm.py
+++ b/tests/vm/aarch64vm.py
@@ -11,11 +11,13 @@
 # the COPYING file in the top-level directory.
 #
 import os
-import sys
 import subprocess
+import sys
+
 import basevm
 from qemu.utils import kvm_available
 
+
 # This is the config needed for current version of QEMU.
 # This works for both kvm and tcg.
 CURRENT_CONFIG = {
@@ -71,22 +73,22 @@ def create_flash_images(flash_dir="./", efi_img=""):
     flash0_path = get_flash_path(flash_dir, "flash0")
     flash1_path = get_flash_path(flash_dir, "flash1")
     fd_null = open(os.devnull, 'w')
-    subprocess.check_call(["dd", "if=/dev/zero", "of={}".format(flash0_path),
+    subprocess.check_call(["dd", "if=/dev/zero", f"of={flash0_path}",
                            "bs=1M", "count=64"],
                            stdout=fd_null, stderr=subprocess.STDOUT)
     # A reliable way to get the QEMU EFI image is via an installed package or
     # via the bios included with qemu.
     if not os.path.exists(efi_img):
-        sys.stderr.write("*** efi argument is invalid ({})\n".format(efi_img))
+        sys.stderr.write(f"*** efi argument is invalid ({efi_img})\n")
         sys.stderr.write("*** please check --efi-aarch64 argument or "\
                          "install qemu-efi-aarch64 package\n")
         exit(3)
-    subprocess.check_call(["dd", "if={}".format(efi_img),
-                           "of={}".format(flash0_path),
+    subprocess.check_call(["dd", f"if={efi_img}",
+                           f"of={flash0_path}",
                            "conv=notrunc"],
                            stdout=fd_null, stderr=subprocess.STDOUT)
     subprocess.check_call(["dd", "if=/dev/zero",
-                           "of={}".format(flash1_path),
+                           f"of={flash1_path}",
                            "bs=1M", "count=64"],
                            stdout=fd_null, stderr=subprocess.STDOUT)
     fd_null.close()
@@ -103,4 +105,4 @@ def get_pflash_args(flash_dir="./"):
     return pflash_args.split(" ")
 
 def get_flash_path(flash_dir, name):
-    return os.path.join(flash_dir, "{}.img".format(name))
+    return os.path.join(flash_dir, f"{name}.img")
diff --git a/tests/vm/basevm.py b/tests/vm/basevm.py
index 9e879e966a3..d4c38915de7 100644
--- a/tests/vm/basevm.py
+++ b/tests/vm/basevm.py
@@ -11,27 +11,28 @@
 # the COPYING file in the top-level directory.
 #
 
+import argparse
+import atexit
+import datetime
+import hashlib
+import json
+import logging
+import multiprocessing
 import os
 import re
-import sys
+import shlex
+import shutil
 import socket
-import logging
-import time
-import datetime
 import subprocess
-import hashlib
-import argparse
-import atexit
+import sys
 import tempfile
-import shutil
-import multiprocessing
+import time
 import traceback
-import shlex
-import json
 
 from qemu.machine import QEMUMachine
 from qemu.utils import get_info_usernet_hostfwd_port, kvm_available
 
+
 SSH_KEY_FILE = os.path.join(os.path.dirname(__file__),
                "..", "keys", "id_rsa")
 SSH_PUB_KEY_FILE = os.path.join(os.path.dirname(__file__),
@@ -65,7 +66,7 @@
                "-drive file={},format=raw,if=none,id=hd0 "\
                "-device scsi-hd,drive=hd0,bootindex=0",
 }
-class BaseVM(object):
+class BaseVM:
 
     envvars = [
         "https_proxy",
@@ -131,7 +132,7 @@ def __init__(self, args, config=None):
         if args.log_console:
                 self._console_log_path = \
                          os.path.join(os.path.expanduser("~/.cache/qemu-vm"),
-                                      "{}.install.log".format(self.name))
+                                      f"{self.name}.install.log")
         self._stderr = sys.stderr
         self._devnull = open(os.devnull, "w")
         if self.debug:
@@ -172,7 +173,7 @@ def __init__(self, args, config=None):
                     # Preserve quotes around arguments.
                     # shlex above takes them out, so add them in.
                     if " " in arg:
-                        arg = '"{}"'.format(arg)
+                        arg = f'"{arg}"'
                     self._config['extra_args'].append(arg)
 
     def validate_ssh_keys(self):
@@ -469,8 +470,8 @@ def gen_cloud_init_iso(self):
         cidir = self._tmpdir
         mdata = open(os.path.join(cidir, "meta-data"), "w")
         name = self.name.replace(".","-")
-        mdata.writelines(["instance-id: {}-vm-0\n".format(name),
-                          "local-hostname: {}-guest\n".format(name)])
+        mdata.writelines([f"instance-id: {name}-vm-0\n",
+                          f"local-hostname: {name}-guest\n"])
         mdata.close()
         udata = open(os.path.join(cidir, "user-data"), "w")
         print("guest user:pw {}:{}".format(self._config['guest_user'],
@@ -510,7 +511,7 @@ def get_qemu_packages_from_lcitool_json(self, json_path=None):
             json_path = os.path.join(
                 os.path.dirname(__file__), "generated", self.name + ".json"
             )
-        with open(json_path, "r") as fh:
+        with open(json_path) as fh:
             return json.load(fh)["pkgs"]
 
 
@@ -546,7 +547,7 @@ def parse_config(config, args):
     else:
         return config
     if not os.path.exists(config_file):
-        raise Exception("config file {} does not exist".format(config_file))
+        raise Exception(f"config file {config_file} does not exist")
     # We gracefully handle importing the yaml module
     # since it might not be installed.
     # If we are here it means the user supplied a .yml file,
diff --git a/tests/vm/centos.aarch64 b/tests/vm/centos.aarch64
index fcf9e08c873..51cc369e6ba 100755
--- a/tests/vm/centos.aarch64
+++ b/tests/vm/centos.aarch64
@@ -13,12 +13,11 @@
 #
 
 import os
-import sys
 import subprocess
-import basevm
-import time
-import traceback
+import sys
+
 import aarch64vm
+import basevm
 
 
 DEFAULT_CONFIG = {
@@ -70,7 +69,7 @@ class CentosAarch64VM(basevm.BaseVM):
             extra_args.extend(["-smp", "8"])
         # We have overridden boot() since aarch64 has additional parameters.
         # Call down to the base class method.
-        super(CentosAarch64VM, self).boot(img, extra_args=extra_args)
+        super().boot(img, extra_args=extra_args)
 
     def build_image(self, img):
         cimg = self._download_with_cache(self.image_link)
@@ -91,7 +90,7 @@ class CentosAarch64VM(basevm.BaseVM):
         self.ssh_root("poweroff")
         self.wait()
         os.rename(img_tmp, img)
-        print("image creation complete: {}".format(img))
+        print(f"image creation complete: {img}")
         return 0
 
 
diff --git a/tests/vm/freebsd b/tests/vm/freebsd
index 74b3b1e520a..72fe4afca50 100755
--- a/tests/vm/freebsd
+++ b/tests/vm/freebsd
@@ -13,13 +13,12 @@
 #
 
 import os
-import re
-import sys
-import time
-import socket
 import subprocess
+import sys
+
 import basevm
 
+
 FREEBSD_CONFIG = {
     'cpu'	: "max,sse4.2=off",
 }
diff --git a/tests/vm/haiku.x86_64 b/tests/vm/haiku.x86_64
index 71cf75a9a3e..c3d26e08f54 100755
--- a/tests/vm/haiku.x86_64
+++ b/tests/vm/haiku.x86_64
@@ -12,13 +12,12 @@
 #
 
 import os
-import re
-import sys
-import time
-import socket
 import subprocess
+import sys
+
 import basevm
 
+
 VAGRANT_KEY_FILE = os.path.join(os.path.dirname(__file__),
     "..", "keys", "vagrant")
 
diff --git a/tests/vm/netbsd b/tests/vm/netbsd
index a3f6dd6b3c8..2f0ddff900b 100755
--- a/tests/vm/netbsd
+++ b/tests/vm/netbsd
@@ -13,11 +13,12 @@
 #
 
 import os
-import sys
-import time
 import subprocess
+import sys
+
 import basevm
 
+
 class NetBSDVM(basevm.BaseVM):
     name = "netbsd"
     arch = "x86_64"
diff --git a/tests/vm/openbsd b/tests/vm/openbsd
index 5e4f76f3988..42bb5b4c8e1 100755
--- a/tests/vm/openbsd
+++ b/tests/vm/openbsd
@@ -13,11 +13,12 @@
 #
 
 import os
-import sys
-import socket
 import subprocess
+import sys
+
 import basevm
 
+
 class OpenBSDVM(basevm.BaseVM):
     name = "openbsd"
     arch = "x86_64"
diff --git a/tests/vm/ubuntu.aarch64 b/tests/vm/ubuntu.aarch64
index eeda281f875..dd45e6cb805 100755
--- a/tests/vm/ubuntu.aarch64
+++ b/tests/vm/ubuntu.aarch64
@@ -13,10 +13,12 @@
 #
 
 import sys
-import basevm
+
 import aarch64vm
+import basevm
 import ubuntuvm
 
+
 DEFAULT_CONFIG = {
     'cpu'          : "cortex-a57",
     'machine'      : "virt,gic-version=3",
@@ -65,7 +67,7 @@ class UbuntuAarch64VM(ubuntuvm.UbuntuVM):
 
         # We have overridden boot() since aarch64 has additional parameters.
         # Call down to the base class method.
-        super(UbuntuAarch64VM, self).boot(img, extra_args=extra_args)
+        super().boot(img, extra_args=extra_args)
 
 if __name__ == "__main__":
     defaults = aarch64vm.get_config_defaults(UbuntuAarch64VM, DEFAULT_CONFIG)
diff --git a/tests/vm/ubuntuvm.py b/tests/vm/ubuntuvm.py
index 15c530c5711..2bfcb257214 100644
--- a/tests/vm/ubuntuvm.py
+++ b/tests/vm/ubuntuvm.py
@@ -14,12 +14,14 @@
 
 import os
 import subprocess
+
 import basevm
 
+
 class UbuntuVM(basevm.BaseVM):
 
     def __init__(self, args, config=None):
-        self.login_prompt = "ubuntu-{}-guest login:".format(self.arch)
+        self.login_prompt = f"ubuntu-{self.arch}-guest login:"
         basevm.BaseVM.__init__(self, args, config)
 
     def build_image(self, img):
@@ -45,7 +47,7 @@ def build_image(self, img):
         # We want to keep the VM system state stable.
         self.ssh_root('sed -ie \'s/"1"/"0"/g\' '\
                       '/etc/apt/apt.conf.d/20auto-upgrades')
-        self.ssh_root("sed -ie s/^#\ deb-src/deb-src/g /etc/apt/sources.list")
+        self.ssh_root(r"sed -ie s/^#\ deb-src/deb-src/g /etc/apt/sources.list")
 
         # If the user chooses not to do the install phase,
         # then we will jump right to the graceful shutdown
-- 
2.48.1


