Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 256AD58D8AE
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 14:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239078AbiHIMVr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 08:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbiHIMVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 08:21:45 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6621614024;
        Tue,  9 Aug 2022 05:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660047703; x=1691583703;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/SqLOHFpZ5uc8Rb+V3yasWUP56wQ9Yw6Pfb06UsviCE=;
  b=Pg4RaMJ+NYp3zK7N3wmqtM4UUsx0JpkyGkX3PqkNYE/MIw4J/ALTD3HW
   4COEJVTs3QNGPgn5ktyK53xen7QiBGu4ZGZFGYTk4fZt2rFe5RfKlrMbn
   VqcJRecNqIB84wCx+rv5aIkcojIL2ewggDCjY9kGEkUvV171SNM6ZnVGs
   QjqfQ5fqZxEyc8vI6ZGJ4pfAW9ahRfT6FRVL7LTV2OrjXjVL4TzGrcI4z
   rbPYKbaN34i5nN+Ki/223M90ANPhT4nv7Go+/IdBFqVeD+bYT//0ZfBr1
   plfjlEAQsdkojkqscgg/c5+Ox2cyP2NXc4ULefwxOXK16M3J84SHL1zrg
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10433"; a="290822906"
X-IronPort-AV: E=Sophos;i="5.93,224,1654585200"; 
   d="scan'208";a="290822906"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 05:21:43 -0700
X-IronPort-AV: E=Sophos;i="5.93,224,1654585200"; 
   d="scan'208";a="664411669"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.48.82])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 05:21:40 -0700
Message-ID: <90a76d0f-78ef-8304-1d22-cc65ce3ad964@intel.com>
Date:   Tue, 9 Aug 2022 15:21:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH 08/35] perf buildid-cache: Add guestmount'd files to the
 build ID cache
Content-Language: en-US
To:     Ian Rogers <irogers@google.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220711093218.10967-1-adrian.hunter@intel.com>
 <20220711093218.10967-9-adrian.hunter@intel.com>
 <CAP-5=fUF_feSL-+=LQpg=6cRd_nXTWKCM4zU1k8TP-6veP26Rw@mail.gmail.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <CAP-5=fUF_feSL-+=LQpg=6cRd_nXTWKCM4zU1k8TP-6veP26Rw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/07/22 20:41, Ian Rogers wrote:
> On Mon, Jul 11, 2022 at 2:33 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>>
>> When the guestmount option is used, a guest machine's file system mount
>> point is recorded in machine->root_dir.
>>
>> perf already iterates guest machines when adding files to the build ID
>> cache, but does not take machine->root_dir into account.
>>
>> Use machine->root_dir to find files for guest build IDs, and add them to
>> the build ID cache using the "proper" name i.e. relative to the guest root
>> directory not the host root directory.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> 
> Is it plausible to add a test for this? Our tests create workload but
> there's no existing hypervisor way to do this. Perhaps the test can
> run in a hypervisor? Or maybe there's a route that doesn't involve
> hypervisors.

Too complicated I think.

> 
> Acked-by: Ian Rogers <irogers@google.com>
> 
> Thanks,
> Ian
> 
>> ---
>>  tools/perf/util/build-id.c | 67 +++++++++++++++++++++++++++++---------
>>  tools/perf/util/build-id.h | 16 ++++++---
>>  2 files changed, 63 insertions(+), 20 deletions(-)
>>
>> diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
>> index 4c9093b64d1f..7c9f441936ee 100644
>> --- a/tools/perf/util/build-id.c
>> +++ b/tools/perf/util/build-id.c
>> @@ -625,9 +625,12 @@ static int build_id_cache__add_sdt_cache(const char *sbuild_id,
>>  #endif
>>
>>  static char *build_id_cache__find_debug(const char *sbuild_id,
>> -                                       struct nsinfo *nsi)
>> +                                       struct nsinfo *nsi,
>> +                                       const char *root_dir)
>>  {
>> +       const char *dirname = "/usr/lib/debug/.build-id/";
>>         char *realname = NULL;
>> +       char dirbuf[PATH_MAX];
>>         char *debugfile;
>>         struct nscookie nsc;
>>         size_t len = 0;
>> @@ -636,8 +639,12 @@ static char *build_id_cache__find_debug(const char *sbuild_id,
>>         if (!debugfile)
>>                 goto out;
>>
>> -       len = __symbol__join_symfs(debugfile, PATH_MAX,
>> -                                  "/usr/lib/debug/.build-id/");
>> +       if (root_dir) {
>> +               path__join(dirbuf, PATH_MAX, root_dir, dirname);
>> +               dirname = dirbuf;
>> +       }
>> +
>> +       len = __symbol__join_symfs(debugfile, PATH_MAX, dirname);
>>         snprintf(debugfile + len, PATH_MAX - len, "%.2s/%s.debug", sbuild_id,
>>                  sbuild_id + 2);
>>
>> @@ -668,14 +675,18 @@ static char *build_id_cache__find_debug(const char *sbuild_id,
>>
>>  int
>>  build_id_cache__add(const char *sbuild_id, const char *name, const char *realname,
>> -                   struct nsinfo *nsi, bool is_kallsyms, bool is_vdso)
>> +                   struct nsinfo *nsi, bool is_kallsyms, bool is_vdso,
>> +                   const char *proper_name, const char *root_dir)
>>  {
>>         const size_t size = PATH_MAX;
>>         char *filename = NULL, *dir_name = NULL, *linkname = zalloc(size), *tmp;
>>         char *debugfile = NULL;
>>         int err = -1;
>>
>> -       dir_name = build_id_cache__cachedir(sbuild_id, name, nsi, is_kallsyms,
>> +       if (!proper_name)
>> +               proper_name = name;
>> +
>> +       dir_name = build_id_cache__cachedir(sbuild_id, proper_name, nsi, is_kallsyms,
>>                                             is_vdso);
>>         if (!dir_name)
>>                 goto out_free;
>> @@ -715,7 +726,7 @@ build_id_cache__add(const char *sbuild_id, const char *name, const char *realnam
>>          */
>>         if (!is_kallsyms && !is_vdso &&
>>             strncmp(".ko", name + strlen(name) - 3, 3)) {
>> -               debugfile = build_id_cache__find_debug(sbuild_id, nsi);
>> +               debugfile = build_id_cache__find_debug(sbuild_id, nsi, root_dir);
>>                 if (debugfile) {
>>                         zfree(&filename);
>>                         if (asprintf(&filename, "%s/%s", dir_name,
>> @@ -781,8 +792,9 @@ build_id_cache__add(const char *sbuild_id, const char *name, const char *realnam
>>         return err;
>>  }
>>
>> -int build_id_cache__add_s(const char *sbuild_id, const char *name,
>> -                         struct nsinfo *nsi, bool is_kallsyms, bool is_vdso)
>> +int __build_id_cache__add_s(const char *sbuild_id, const char *name,
>> +                           struct nsinfo *nsi, bool is_kallsyms, bool is_vdso,
>> +                           const char *proper_name, const char *root_dir)
>>  {
>>         char *realname = NULL;
>>         int err = -1;
>> @@ -796,8 +808,8 @@ int build_id_cache__add_s(const char *sbuild_id, const char *name,
>>                         goto out_free;
>>         }
>>
>> -       err = build_id_cache__add(sbuild_id, name, realname, nsi, is_kallsyms, is_vdso);
>> -
>> +       err = build_id_cache__add(sbuild_id, name, realname, nsi,
>> +                                 is_kallsyms, is_vdso, proper_name, root_dir);
>>  out_free:
>>         if (!is_kallsyms)
>>                 free(realname);
>> @@ -806,14 +818,16 @@ int build_id_cache__add_s(const char *sbuild_id, const char *name,
>>
>>  static int build_id_cache__add_b(const struct build_id *bid,
>>                                  const char *name, struct nsinfo *nsi,
>> -                                bool is_kallsyms, bool is_vdso)
>> +                                bool is_kallsyms, bool is_vdso,
>> +                                const char *proper_name,
>> +                                const char *root_dir)
>>  {
>>         char sbuild_id[SBUILD_ID_SIZE];
>>
>>         build_id__sprintf(bid, sbuild_id);
>>
>> -       return build_id_cache__add_s(sbuild_id, name, nsi, is_kallsyms,
>> -                                    is_vdso);
>> +       return __build_id_cache__add_s(sbuild_id, name, nsi, is_kallsyms,
>> +                                      is_vdso, proper_name, root_dir);
>>  }
>>
>>  bool build_id_cache__cached(const char *sbuild_id)
>> @@ -896,6 +910,10 @@ static int dso__cache_build_id(struct dso *dso, struct machine *machine,
>>         bool is_kallsyms = dso__is_kallsyms(dso);
>>         bool is_vdso = dso__is_vdso(dso);
>>         const char *name = dso->long_name;
>> +       const char *proper_name = NULL;
>> +       const char *root_dir = NULL;
>> +       char *allocated_name = NULL;
>> +       int ret = 0;
>>
>>         if (!dso->has_build_id)
>>                 return 0;
>> @@ -905,11 +923,28 @@ static int dso__cache_build_id(struct dso *dso, struct machine *machine,
>>                 name = machine->mmap_name;
>>         }
>>
>> +       if (!machine__is_host(machine)) {
>> +               if (*machine->root_dir) {
>> +                       root_dir = machine->root_dir;
>> +                       ret = asprintf(&allocated_name, "%s/%s", root_dir, name);
>> +                       if (ret < 0)
>> +                               return ret;
>> +                       proper_name = name;
>> +                       name = allocated_name;
>> +               } else if (is_kallsyms) {
>> +                       /* Cannot get guest kallsyms */
>> +                       return 0;
>> +               }
>> +       }
>> +
>>         if (!is_kallsyms && dso__build_id_mismatch(dso, name))
>> -               return 0;
>> +               goto out_free;
>>
>> -       return build_id_cache__add_b(&dso->bid, name, dso->nsinfo,
>> -                                    is_kallsyms, is_vdso);
>> +       ret = build_id_cache__add_b(&dso->bid, name, dso->nsinfo,
>> +                                   is_kallsyms, is_vdso, proper_name, root_dir);
>> +out_free:
>> +       free(allocated_name);
>> +       return ret;
>>  }
>>
>>  static int
>> diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
>> index c19617151670..4e3a1169379b 100644
>> --- a/tools/perf/util/build-id.h
>> +++ b/tools/perf/util/build-id.h
>> @@ -66,10 +66,18 @@ int build_id_cache__list_build_ids(const char *pathname, struct nsinfo *nsi,
>>                                    struct strlist **result);
>>  bool build_id_cache__cached(const char *sbuild_id);
>>  int build_id_cache__add(const char *sbuild_id, const char *name, const char *realname,
>> -                       struct nsinfo *nsi, bool is_kallsyms, bool is_vdso);
>> -int build_id_cache__add_s(const char *sbuild_id,
>> -                         const char *name, struct nsinfo *nsi,
>> -                         bool is_kallsyms, bool is_vdso);
>> +                       struct nsinfo *nsi, bool is_kallsyms, bool is_vdso,
>> +                       const char *proper_name, const char *root_dir);
>> +int __build_id_cache__add_s(const char *sbuild_id,
>> +                           const char *name, struct nsinfo *nsi,
>> +                           bool is_kallsyms, bool is_vdso,
>> +                           const char *proper_name, const char *root_dir);
>> +static inline int build_id_cache__add_s(const char *sbuild_id,
>> +                                       const char *name, struct nsinfo *nsi,
>> +                                       bool is_kallsyms, bool is_vdso)
>> +{
>> +       return __build_id_cache__add_s(sbuild_id, name, nsi, is_kallsyms, is_vdso, NULL, NULL);
>> +}
>>  int build_id_cache__remove_s(const char *sbuild_id);
>>
>>  extern char buildid_dir[];
>> --
>> 2.25.1
>>

