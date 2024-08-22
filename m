Return-Path: <kvm+bounces-24854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9CF195BFFD
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 22:57:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BEEF286A10
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 20:56:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79DE41D1731;
	Thu, 22 Aug 2024 20:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0SyAckyf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4251D04B5
	for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 20:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724360205; cv=none; b=VDAAmgoMAPNkft12LDdxEkTTVfG/U4nk6OpN2htxqzsBNMGKe86UGefzMoO/3hNFadqt6M+NA/ZDDFq4KhJ/8hClN9RontMxAQOgxfrUqAOkNuIX5cAG6Xu8YKYITOqoTODlqlGm+vpCaYwt8yGupk0keRcKJ9CdZoL5W5gAthk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724360205; c=relaxed/simple;
	bh=EwhNycLdVgwhx/6sMa+Dp37wikg8S1VmHKbChJwiHQo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CdRp9xBKJa8JFYgkfjsdb+xoZLU+1+bIHrOYYFI5zwws/jdfdaLGmyrA27dAph4TT9B4oxXnbdLkQFVwkwjhktSLAer+g5mFyGa+rf1dJn86rJ25CJYUAGKlF0DUem1vUpzVhyzTOqyZQ4tTv7+IyMK07NKGCk475s8ylK2w1gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0SyAckyf; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5bec507f4ddso5742a12.0
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 13:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724360201; x=1724965001; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oIL9gwu/tM6nz5oQ+peTYqQ8UKt4fZ/1TQ5587EjLPQ=;
        b=0SyAckyf3I1HIWzq9A9KaoXkeul0p6OxY2rGf6301KN6ArD/W3SIM3A2a2qPuX36xq
         /wQSfmzQXdc5yruOSGR1XjNN8j6GAF2WAA4FCaWx0SNsyZfrurI2GXR5F0Gt/PGYjhg3
         Md2OLSOLvWp1za9FSm1DJ1KfR4A0SUd5kDTEJJUz0Y1HcS9A4jv1SxTWhWAGni2XpUoS
         4bJY+GNGDiWnSRB75CCsP1v1qDIoULCj4vDRroxPTFunvZ357r3nwSpA0UDzHgiWK5Jw
         9MCT4OfQlb8O2sj43swvbUoOqHZwjYixis8dTL9eszAE5Wpsi9ll4jR0I0oSIMtQhL70
         xFEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724360201; x=1724965001;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oIL9gwu/tM6nz5oQ+peTYqQ8UKt4fZ/1TQ5587EjLPQ=;
        b=cvTAVaElqmrWq+gyUXMTTkqN+zx9ketSObJ30uuMVtnixL7v3lTyWIxNw4iYR2kmxy
         kgoed4tef8kL2NqatQefPJg4U6yoKLMeXc/xYBEsUvAzmUqszeBJll/aCoLTeNlDosci
         3MQDNdPkZscqF18bx9ZAUZO4TL4mBGHNc9xDmuAAvoLwbm15FtvV36fb2EhPjnXMgF9K
         az1F9ZZhWTtBmPhuURLoPNRQpRsIICxiqScC+F7eKzsUgHGF/mrqz7STCT7d5kafllqv
         Mee5/+aEkCy3+NUhA+GrBb2yd+yhEKo6tBPoJ+wSqR2ZKO7YpJjX0q6JJhzpzihEOzo1
         0Y6A==
X-Gm-Message-State: AOJu0YyOuF2M6n5imqX2OWH/Q7jvTWa2VczRwwQ0qKxDVEZaLA0GsFHH
	Tx2kL0bnj7jiyuoYb8L3lYYsHhv/oy3Q5Dcfmp36OGyEZZhF4+KRC56w52SeBjvFgUV27udNV/0
	rvSuKz7jSmMT15n58ILO9eDK6qKVklilY0d0BxS9c/0JcCX3r5U2kk/U=
X-Google-Smtp-Source: AGHT+IHUsYpUeIaCVilI9OGK4wC2ThNOGQCRlErjcHb4Ba+O/X/lmdzYB9VN1Qd5v5oKHjDjr0Izgl+wV4Q571B6/DI=
X-Received: by 2002:a05:6402:40c5:b0:5be:ce7d:ad0d with SMTP id
 4fb4d7f45d1cf-5c086ad8aa2mr66287a12.0.1724360201062; Thu, 22 Aug 2024
 13:56:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240821223012.3757828-1-vipinsh@google.com> <20240821223012.3757828-2-vipinsh@google.com>
In-Reply-To: <20240821223012.3757828-2-vipinsh@google.com>
From: Vipin Sharma <vipinsh@google.com>
Date: Thu, 22 Aug 2024 13:56:03 -0700
Message-ID: <CAHVum0dkqtOMayD8wgS3jHGMkGxehZoB-U3x-Y4yMyyG74LvdQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] KVM: selftestsi: Create KVM selftests runnner to run
 interesting tests
To: KVM <kvm@vger.kernel.org>, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Anup Patel <anup@brainfault.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Oops! Adding archs mailing list and maintainers which have arch folder
in tool/testing/selftests/kvm

On Wed, Aug 21, 2024 at 3:30=E2=80=AFPM Vipin Sharma <vipinsh@google.com> w=
rote:
>
> Create a selftest runner "runner.py" for KVM which can run tests with
> more interesting configurations other than the default values. Read
> those configurations from "tests.json".
>
> Provide runner some options to run differently:
> 1. Run using different configuration files.
> 2. Run specific test suite or test in a specific suite.
> 3. Allow some setup and teardown capability for each test and test suite
>    execution.
> 4. Timeout value for tests.
> 5. Run test suite parallelly.
> 6. Dump stdout and stderror in hierarchical folder structure.
> 7. Run/skip tests based on platform it is executing on.
>
> Print summary of the run at the end.
>
> Add a starter test configuration file "tests.json" with some sample
> tests which runner can use to execute tests.
>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  tools/testing/selftests/kvm/runner.py  | 282 +++++++++++++++++++++++++
>  tools/testing/selftests/kvm/tests.json |  60 ++++++
>  2 files changed, 342 insertions(+)
>  create mode 100755 tools/testing/selftests/kvm/runner.py
>  create mode 100644 tools/testing/selftests/kvm/tests.json
>
> diff --git a/tools/testing/selftests/kvm/runner.py b/tools/testing/selfte=
sts/kvm/runner.py
> new file mode 100755
> index 000000000000..46f6c1c8ce2c
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/runner.py
> @@ -0,0 +1,282 @@
> +#!/usr/bin/env python3
> +
> +import argparse
> +import json
> +import subprocess
> +import os
> +import platform
> +import logging
> +import contextlib
> +import textwrap
> +import shutil
> +
> +from pathlib import Path
> +from multiprocessing import Pool
> +
> +logging.basicConfig(level=3Dlogging.INFO,
> +                    format =3D "%(asctime)s | %(process)d | %(levelname)=
8s | %(message)s")
> +
> +class Command:
> +    """Executes a command
> +
> +    Execute a command.
> +    """
> +    def __init__(self, id, command, timeout=3DNone, command_artifacts_di=
r=3DNone):
> +        self.id =3D id
> +        self.args =3D command
> +        self.timeout =3D timeout
> +        self.command_artifacts_dir =3D command_artifacts_dir
> +
> +    def __run(self, command, timeout=3DNone, output=3DNone, error=3DNone=
):
> +            proc=3Dsubprocess.run(command, stdout=3Doutput,
> +                                stderr=3Derror, universal_newlines=3DTru=
e,
> +                                shell=3DTrue, timeout=3Dtimeout)
> +            return proc.returncode
> +
> +    def run(self):
> +        output =3D None
> +        error =3D None
> +        with contextlib.ExitStack() as stack:
> +            if self.command_artifacts_dir is not None:
> +                output_path =3D os.path.join(self.command_artifacts_dir,=
 f"{self.id}.stdout")
> +                error_path =3D os.path.join(self.command_artifacts_dir, =
f"{self.id}.stderr")
> +                output =3D stack.enter_context(open(output_path, encodin=
g=3D"utf-8", mode =3D "w"))
> +                error =3D stack.enter_context(open(error_path, encoding=
=3D"utf-8", mode =3D "w"))
> +            return self.__run(self.args, self.timeout, output, error)
> +
> +COMMAND_TIMED_OUT =3D "TIMED_OUT"
> +COMMAND_PASSED =3D "PASSED"
> +COMMAND_FAILED =3D "FAILED"
> +COMMAND_SKIPPED =3D "SKIPPED"
> +SETUP_FAILED =3D "SETUP_FAILED"
> +TEARDOWN_FAILED =3D "TEARDOWN_FAILED"
> +
> +def run_command(command):
> +    if command is None:
> +        return COMMAND_PASSED
> +
> +    try:
> +        ret =3D command.run()
> +        if ret =3D=3D 0:
> +            return COMMAND_PASSED
> +        elif ret =3D=3D 4:
> +            return COMMAND_SKIPPED
> +        else:
> +            return COMMAND_FAILED
> +    except subprocess.TimeoutExpired as e:
> +        logging.error(type(e).__name__ + str(e))
> +        return COMMAND_TIMED_OUT
> +
> +class Test:
> +    """A single test.
> +
> +    A test which can be run on its own.
> +    """
> +    def __init__(self, test_json, timeout=3DNone, suite_dir=3DNone):
> +        self.name =3D test_json["name"]
> +        self.test_artifacts_dir =3D None
> +        self.setup_command =3D None
> +        self.teardown_command =3D None
> +
> +        if suite_dir is not None:
> +            self.test_artifacts_dir =3D os.path.join(suite_dir, self.nam=
e)
> +
> +        test_timeout =3D test_json.get("timeout_s", timeout)
> +
> +        self.test_command =3D Command("command", test_json["command"], t=
est_timeout, self.test_artifacts_dir)
> +        if "setup" in test_json:
> +            self.setup_command =3D Command("setup", test_json["setup"], =
test_timeout, self.test_artifacts_dir)
> +        if "teardown" in test_json:
> +            self.teardown_command =3D Command("teardown", test_json["tea=
rdown"], test_timeout, self.test_artifacts_dir)
> +
> +    def run(self):
> +        if self.test_artifacts_dir is not None:
> +            Path(self.test_artifacts_dir).mkdir(parents=3DTrue, exist_ok=
=3DTrue)
> +
> +        setup_status =3D run_command(self.setup_command)
> +        if setup_status !=3D COMMAND_PASSED:
> +            return SETUP_FAILED
> +
> +        try:
> +            status =3D run_command(self.test_command)
> +            return status
> +        finally:
> +            teardown_status =3D run_command(self.teardown_command)
> +            if (teardown_status !=3D COMMAND_PASSED
> +                    and (status =3D=3D COMMAND_PASSED or status =3D=3D C=
OMMAND_SKIPPED)):
> +                return TEARDOWN_FAILED
> +
> +def run_test(test):
> +    return test.run()
> +
> +class Suite:
> +    """Collection of tests to run
> +
> +    Group of tests.
> +    """
> +    def __init__(self, suite_json, platform_arch, artifacts_dir, test_fi=
lter):
> +        self.suite_name =3D suite_json["suite"]
> +        self.suite_artifacts_dir =3D None
> +        self.setup_command =3D None
> +        self.teardown_command =3D None
> +        timeout =3D suite_json.get("timeout_s", None)
> +
> +        if artifacts_dir is not None:
> +            self.suite_artifacts_dir =3D os.path.join(artifacts_dir, sel=
f.suite_name)
> +
> +        if "setup" in suite_json:
> +            self.setup_command =3D Command("setup", suite_json["setup"],=
 timeout, self.suite_artifacts_dir)
> +        if "teardown" in suite_json:
> +            self.teardown_command =3D Command("teardown", suite_json["te=
ardown"], timeout, self.suite_artifacts_dir)
> +
> +        self.tests =3D []
> +        for test_json in suite_json["tests"]:
> +            if len(test_filter) > 0 and test_json["name"] not in test_fi=
lter:
> +                continue;
> +            if test_json.get("arch") is None or test_json["arch"] =3D=3D=
 platform_arch:
> +                self.tests.append(Test(test_json, timeout, self.suite_ar=
tifacts_dir))
> +
> +    def run(self, jobs=3D1):
> +        result =3D {}
> +        if len(self.tests) =3D=3D 0:
> +            return COMMAND_PASSED, result
> +
> +        if self.suite_artifacts_dir is not None:
> +            Path(self.suite_artifacts_dir).mkdir(parents =3D True, exist=
_ok =3D True)
> +
> +        setup_status =3D run_command(self.setup_command)
> +        if setup_status !=3D COMMAND_PASSED:
> +            return SETUP_FAILED, result
> +
> +
> +        if jobs > 1:
> +            with Pool(jobs) as p:
> +                tests_status =3D p.map(run_test, self.tests)
> +            for i,test in enumerate(self.tests):
> +                logging.info(f"{tests_status[i]}: {self.suite_name}/{tes=
t.name}")
> +                result[test.name] =3D tests_status[i]
> +        else:
> +            for test in self.tests:
> +                status =3D run_test(test)
> +                logging.info(f"{status}: {self.suite_name}/{test.name}")
> +                result[test.name] =3D status
> +
> +        teardown_status =3D run_command(self.teardown_command)
> +        if teardown_status !=3D COMMAND_PASSED:
> +            return TEARDOWN_FAILED, result
> +
> +
> +        return COMMAND_PASSED, result
> +
> +def load_tests(path):
> +    with open(path) as f:
> +        tests =3D json.load(f)
> +    return tests
> +
> +
> +def run_suites(suites, jobs):
> +    """Runs the tests.
> +
> +    Run test suits in the tests file.
> +    """
> +    result =3D {}
> +    for suite in suites:
> +        result[suite.suite_name] =3D suite.run(jobs)
> +    return result
> +
> +def parse_test_filter(test_suite_or_test):
> +    test_filter =3D {}
> +    if len(test_suite_or_test) =3D=3D 0:
> +        return test_filter
> +    for test in test_suite_or_test:
> +        test_parts =3D test.split("/")
> +        if len(test_parts) > 2:
> +            raise ValueError("Incorrect format of suite/test_name combo"=
)
> +        if test_parts[0] not in test_filter:
> +            test_filter[test_parts[0]] =3D []
> +        if len(test_parts) =3D=3D 2:
> +            test_filter[test_parts[0]].append(test_parts[1])
> +
> +    return test_filter
> +
> +def parse_suites(suites_json, platform_arch, artifacts_dir, test_suite_o=
r_test):
> +    suites =3D []
> +    test_filter =3D parse_test_filter(test_suite_or_test)
> +    for suite_json in suites_json:
> +        if len(test_filter) > 0 and suite_json["suite"] not in test_filt=
er:
> +            continue
> +        if suite_json.get("arch") is None or suite_json["arch"] =3D=3D p=
latform_arch:
> +            suites.append(Suite(suite_json,
> +                                platform_arch,
> +                                artifacts_dir,
> +                                test_filter.get(suite_json["suite"], [])=
))
> +    return suites
> +
> +
> +def pretty_print(result):
> +    logging.info("------------------------------------------------------=
--------------------")
> +    if not result:
> +        logging.warning("No test executed.")
> +        return
> +    logging.info("Test runner result:")
> +    suite_count =3D 0
> +    test_count =3D 0
> +    for suite_name, suite_result in result.items():
> +        suite_count +=3D 1
> +        logging.info(f"{suite_count}) {suite_name}:")
> +        if suite_result[0] !=3D COMMAND_PASSED:
> +            logging.info(f"\t{suite_result[0]}")
> +        test_count =3D 0
> +        for test_name, test_result in suite_result[1].items():
> +            test_count +=3D 1
> +            if test_result =3D=3D "PASSED":
> +                logging.info(f"\t{test_count}) {test_result}: {test_name=
}")
> +            else:
> +                logging.error(f"\t{test_count}) {test_result}: {test_nam=
e}")
> +    logging.info("------------------------------------------------------=
--------------------")
> +
> +def args_parser():
> +    parser =3D argparse.ArgumentParser(
> +        prog =3D "KVM Selftests Runner",
> +        description =3D "Run KVM selftests with different configurations=
",
> +        formatter_class=3Dargparse.RawTextHelpFormatter
> +    )
> +
> +    parser.add_argument("-o","--output",
> +                        help=3D"Creates a folder to dump test results.")
> +    parser.add_argument("-j", "--jobs", default =3D 1, type =3D int,
> +                        help=3D"Number of parallel executions in a suite=
")
> +    parser.add_argument("test_suites_json",
> +                        help =3D "File containing test suites to run")
> +
> +    test_suite_or_test_help =3D textwrap.dedent("""\
> +                               Run specific test suite or specific test =
from the test suite.
> +                               If nothing specified then run all of the =
tests.
> +
> +                               Example:
> +                                   runner.py tests.json A/a1 A/a4 B C/c1
> +
> +                               Assuming capital letters are test suites =
and small letters are tests.
> +                               Runner will:
> +                               - Run test a1 and a4 from the test suite =
A
> +                               - Run all tests from the test suite B
> +                               - Run test c1 from the test suite C"""
> +                               )
> +    parser.add_argument("test_suite_or_test", nargs=3D"*", help=3Dtest_s=
uite_or_test_help)
> +
> +
> +    return parser.parse_args();
> +
> +def main():
> +    args =3D args_parser()
> +    suites_json =3D load_tests(args.test_suites_json)
> +    suites =3D parse_suites(suites_json, platform.machine(),
> +                          args.output, args.test_suite_or_test)
> +
> +    if args.output is not None:
> +        shutil.rmtree(args.output, ignore_errors=3DTrue)
> +    result =3D run_suites(suites, args.jobs)
> +    pretty_print(result)
> +
> +if __name__ =3D=3D "__main__":
> +    main()
> diff --git a/tools/testing/selftests/kvm/tests.json b/tools/testing/selft=
ests/kvm/tests.json
> new file mode 100644
> index 000000000000..1c1c15a0e880
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/tests.json
> @@ -0,0 +1,60 @@
> +[
> +        {
> +                "suite": "dirty_log_perf_tests",
> +                "timeout_s": 300,
> +                "tests": [
> +                        {
> +                                "name": "dirty_log_perf_test_max_vcpu_no=
_manual_protect",
> +                                "command": "./dirty_log_perf_test -v $(g=
rep -c ^processor /proc/cpuinfo) -g"
> +                        },
> +                        {
> +                                "name": "dirty_log_perf_test_max_vcpu_ma=
nual_protect",
> +                                "command": "./dirty_log_perf_test -v $(g=
rep -c ^processor /proc/cpuinfo)"
> +                        },
> +                        {
> +                                "name": "dirty_log_perf_test_max_vcpu_ma=
nual_protect_random_access",
> +                                "command": "./dirty_log_perf_test -v $(g=
rep -c ^processor /proc/cpuinfo) -a"
> +                        },
> +                        {
> +                                "name": "dirty_log_perf_test_max_10_vcpu=
_hugetlb",
> +                                "setup": "echo 5120 > /sys/kernel/mm/hug=
epages/hugepages-2048kB/nr_hugepages",
> +                                "command": "./dirty_log_perf_test -v 10 =
-s anonymous_hugetlb_2mb",
> +                                "teardown": "echo 0 > /sys/kernel/mm/hug=
epages/hugepages-2048kB/nr_hugepages"
> +                        }
> +                ]
> +        },
> +        {
> +                "suite": "x86_sanity_tests",
> +                "arch" : "x86_64",
> +                "tests": [
> +                        {
> +                                "name": "vmx_msrs_test",
> +                                "command": "./x86_64/vmx_msrs_test"
> +                        },
> +                        {
> +                                "name": "private_mem_conversions_test",
> +                                "command": "./x86_64/private_mem_convers=
ions_test"
> +                        },
> +                        {
> +                                "name": "apic_bus_clock_test",
> +                                "command": "./x86_64/apic_bus_clock_test=
"
> +                        },
> +                        {
> +                                "name": "dirty_log_page_splitting_test",
> +                                "command": "./x86_64/dirty_log_page_spli=
tting_test -b 2G -s anonymous_hugetlb_2mb",
> +                                "setup": "echo 2560 > /sys/kernel/mm/hug=
epages/hugepages-2048kB/nr_hugepages",
> +                                "teardown": "echo 0 > /sys/kernel/mm/hug=
epages/hugepages-2048kB/nr_hugepages"
> +                        }
> +                ]
> +        },
> +        {
> +                "suite": "arm_sanity_test",
> +                "arch" : "aarch64",
> +                "tests": [
> +                        {
> +                                "name": "page_fault_test",
> +                                "command": "./aarch64/page_fault_test"
> +                        }
> +                ]
> +        }
> +]
> \ No newline at end of file
> --
> 2.46.0.184.g6999bdac58-goog
>

